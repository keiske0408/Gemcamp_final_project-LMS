class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader
  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  belongs_to :member_level, class_name: 'MemberLevel', optional: true
  has_many :children, class_name: 'User', foreign_key: :parent_id
  has_many :locations, class_name: 'Location'
  has_many :tickets, class_name: 'Ticket'
  has_many :orders
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :increment_parent_children_count, if: -> { parent.present? }
  after_create :check_member_level

  enum genre: { client: 0, admin: 1 }

  ROLES = %w[admin client].freeze
  validates :coins, numericality: { greater_than_or_equal_to: 0 }
  validates :total_deposit, numericality: { greater_than_or_equal_to: 0 }
  validates :role, inclusion: { in: ROLES }
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  def coins_used_count
    tickets.sum(:coins)
  end

  private

  def increment_parent_children_count
    parent.increment!(:children_members)
  end

  def location_limit
    errors.add(:locations, "limit of 5 addresses per user") if locations.size > 5
  end

  def check_member_level
    return unless parent.present?

    promoter_member_count = parent.children_members
    promoter_member_level = parent.member_level

    Rails.logger.debug "Promoter Member Count: #{promoter_member_count}"
    Rails.logger.debug "Promoter Member Level: #{promoter_member_level&.level}"


    next_member_level = MemberLevel.find_by("level > ?", promoter_member_level&.level || 0)

    Rails.logger.debug "Next Member Level: #{next_member_level.inspect}"

    if next_member_level && promoter_member_count >= next_member_level.required_members
      Rails.logger.debug "Promoter qualifies for next level!"
      promoter_order = parent.orders.create(genre: "member_level", coin: next_member_level.coins)
      promoter_order.pay!
      parent.update(member_level: next_member_level)
    end
  end
end

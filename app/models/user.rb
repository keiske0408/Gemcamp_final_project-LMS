class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader

  enum genre: { client: 0, admin: 1 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin client].freeze

  validates :role, inclusion: { in: ROLES }

  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  has_many :locations, class_name: 'Location'

  private

  def location_limit
    errors.add(:locations, "limit of 5 addresses per user") if locations.size > 5
  end

end

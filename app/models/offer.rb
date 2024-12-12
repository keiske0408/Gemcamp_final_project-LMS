class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }
  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4 }

  validates :status, inclusion: { in: statuses.keys }
  validates :name, :amount, :coin, presence: true
  validates :amount, :coin, numericality: { greater_than: 0 }

  scope :active, -> { where(status: :active) }

  def can_be_purchased_by?(user)
    orders = user.orders.where(offer_id: id)

    case genre
    when "one_time"
      orders.none? { |order| !order.cancelled? }
    when "monthly"
      orders.none? { |order| !order.cancelled? && order.created_at.between?(Time.current.beginning_of_month, Time.current.end_of_month) }
    when "weekly"
      orders.none? { |order| !order.cancelled? && order.created_at.between?(Time.current.beginning_of_week, Time.current.end_of_week) }
    when "daily"
      orders.none? { |order| !order.cancelled? && order.created_at.between?(Time.current.beginning_of_day, Time.current.end_of_day) }
    when "regular"
      true
    else
      false
    end
  end
end

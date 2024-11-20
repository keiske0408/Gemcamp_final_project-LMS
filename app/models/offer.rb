class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }

  validates :name, :amount, :coin, presence: true
  validates :amount, :coin, numericality: { greater_than: 0 }
end

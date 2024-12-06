class Banner < ApplicationRecord
  acts_as_paranoid

  mount_uploader :preview, ImageUploader
  validates :preview, presence: true
  validates :status, presence: true
  enum status: { inactive: 0, active: 1 }
end

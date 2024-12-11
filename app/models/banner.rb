class Banner < ApplicationRecord
  acts_as_paranoid

  default_scope { order(:sort) }
  validates :sort, numericality: { only_integer: true, allow_nil: true,greater_than_or_equal_to: 0 }

  mount_uploader :preview, ImageUploader
  validates :preview, presence: true
  validates :status, presence: true
  enum status: { inactive: 0, active: 1 }
end

class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User', optional: true
  default_scope { order(:sort) }
  validates :sort, numericality: { only_integer: true, allow_nil: true,greater_than_or_equal_to: 0}

  acts_as_paranoid

  validates :status, presence: true
  enum status: { inactive: 0, active: 1 }

end

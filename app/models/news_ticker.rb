class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User', optional: true

  acts_as_paranoid

  validates :status, presence: true
  enum status: { inactive: 0, active: 1 }

end

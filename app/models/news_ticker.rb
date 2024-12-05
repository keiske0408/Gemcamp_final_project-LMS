class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User', optional: true

  acts_as_paranoid

  validates :content, presence: true
  validates :status, inclusion: { in: ['active', 'inactive'] }
end

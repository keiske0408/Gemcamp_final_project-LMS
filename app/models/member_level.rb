class MemberLevel < ApplicationRecord
  validates :required_members, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :user
end

class Banner < ApplicationRecord
  acts_as_paranoid

  validates :preview, presence: true
  validates :status, inclusion: { in: %w[active inactive] }

end

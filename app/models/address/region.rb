class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :provinces, class_name: 'Address::Province'
  has_many :cities, through: :provinces
  has_many :locations, class_name: 'Location', foreign_key: 'address_region_id'
end

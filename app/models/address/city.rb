class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province, class_name: 'Address::Province'
  has_many :barangays, class_name: 'Address::Barangay'
  has_many :locations, class_name: 'Location', foreign_key: 'address_city_id'
end

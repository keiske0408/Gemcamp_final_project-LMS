class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city, class_name: 'Address::City'
  has_many :locations, class_name: 'Location', foreign_key: 'address_barangay_id'
end

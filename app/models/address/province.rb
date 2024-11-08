class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :region, class_name: 'Address::Region'
  has_many :cities, class_name: 'Address::City'
  has_many :locations,  class_name: 'Location', foreign_key: 'address_province_id'
end

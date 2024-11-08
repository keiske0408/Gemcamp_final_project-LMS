class ClientAddress < ApplicationRecord
  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay

  enum genre: { home: 0, office: 1 }

  validates :genre, presence: true
  validates :name, presence: true
  validates :street_address, presence: true
  validates :phone_number, presence: true
end

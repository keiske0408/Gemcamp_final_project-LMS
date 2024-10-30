class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum genre: { client: 0, admin: 1 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin client].freeze

  validates :role, inclusion: { in: ROLES }

  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  def admin?
    role == 'admin' # Adjust this based on your actual role logic
  end

  def client?
    role == 'client' # Adjust this based on your actual role logic
  end
end

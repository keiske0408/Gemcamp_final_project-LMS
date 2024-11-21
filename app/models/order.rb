class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true

  enum genre: {
    deposit: 0,
    increase: 1,
    deduct: 2,
    bonus: 3,
    share: 4,
  }

  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :submitted
    state :cancelled
    state :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
      transitions from: :submitted, to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :process_payment
    end

    event :revert_payment do
      transitions from: :paid, to: :cancelled, after: :revert_payment_actions
    end
  end

  # Generate serial number before saving
  before_create :generate_serial_number

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: -> { deposit? }
  validates :coin, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

  # Generate serial number based on the format
  def generate_serial_number
    number_count = Order.where(user_id: user_id).count + 1
    formatted_count = number_count.to_s.rjust(4, '0')
    self.serial_number = "#{Time.current.strftime('%y%m%d')}-#{id || '0'}-#{user_id}-#{formatted_count}"
  end

  # Process payment based on genre
  def process_payment
    case genre.to_sym
    when :deduct
      user.decrement!(:coins, coin)
    else
      user.increment!(:coins, coin)
    end
    user.increment!(:total_deposit, amount) if deposit?
  end

  # Revert payment when cancelled
  def revert_payment_actions
    case genre.to_sym
    when :deduct
      user.increment!(:coins, coin)
    else
      raise "Insufficient coins for refund" if user.coins < coin
      user.decrement!(:coins, coin)
    end
    user.decrement!(:total_deposit, amount) if deposit?
  end
end

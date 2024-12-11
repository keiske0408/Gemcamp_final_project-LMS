class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :offer, optional: true

  scope :filter_by_serial_number, ->(serial_number) { where("serial_number LIKE ?", "%#{serial_number}%") if serial_number.present? }
  scope :filter_by_email, ->(email) { joins(:user).where("users.email LIKE ?", "%#{email}%") if email.present? }
  scope :filter_by_genre, ->(genre) { where(genre: genre) if genre.present? }
  scope :filter_by_state, ->(state) { where(state: state) if state.present? }
  scope :filter_by_offer, ->(offer_id) { where(offer_id: offer_id) if offer_id.present? }
  scope :filter_by_date_range, ->(start_date, end_date) {
    where(created_at: start_date..end_date) if start_date.present? && end_date.present?
  }

  enum genre: {
    deposit: 0,
    increase: 1,
    deduct: 2,
    bonus: 3,
    share: 4,
    member_level: 5,
  }

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
      transitions from: :pending, to: :paid, guard: -> { !deposit? }, after: :process_payment
    end

    event :revert_payment do
      transitions from: :paid, to: :cancelled, after: :revert_payment_actions
    end
  end

  before_create :generate_serial_number

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: -> { deposit? }
  validates :coin, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :remarks, presence: true, if: -> { increase? || deduct? || bonus? }

  def generate_serial_number
    number_count = Order.where(user_id: user_id).count + 1
    formatted_count = number_count.to_s.rjust(4, '0')
    "#{Time.current.strftime('%y%m%d')}-#{id || '0'}-#{user_id}-#{formatted_count}"
  end

  private

  def process_payment
    case genre.to_sym
    when :deduct
      user.decrement!(:coins, coin)
    else
      user.increment!(:coins, coin)
    end
    user.increment!(:total_deposit, amount) if deposit?
  end

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

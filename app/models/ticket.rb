class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :item
  before_validation :generate_serial_number , on: :create
  after_create :subtract_coin_from_user


  include AASM

  validates :serial_number, presence: true, uniqueness: true

  enum state: { pending: 0, won: 1, lost: 2, cancelled: 3 }

  aasm :state do
    state :pending, initial: true
    state :won
    state :lost
    state :cancelled

    event :win do
      transitions pending: :won
    end

    event :lose do
      transitions pending: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled,
                  success: :refund_coin_if_cancelled
      transitions after: :cancel_associated_tickets
    end
  end

  def cancel_associated_tickets
    tickets.each { |ticket| ticket.cancel! }
  end

  private

  def generate_serial_number
    number_count = Ticket.where(item_id: item_id, batch_count: batch_count).count
    formatted_number_count = number_count.to_s.rjust(4, '0')
    time = Time.current.strftime("%y%m%d")
    self.serial_number = "#{time}-#{item.id}-#{item.batch_count}-#{formatted_number_count}"
  end

  def subtract_coin_from_user
    user.decrement!(:coins, 1)
  end

  def refund_coin_if_cancelled
    user.increment!(:coins, 1)
  end

end


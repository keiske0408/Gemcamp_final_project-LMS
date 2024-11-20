class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  default_scope { where(deleted_at: nil) }
  enum status: { inactive: 0, active: 1 }

  validate :cannot_be_deleted_if_tickets_exist, on: :destroy
  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
  has_many :tickets
  has_many :winners
  before_destroy :check_for_associated_tickets

  include AASM

  # AASM for the main lifecycle of the item
  aasm column: 'state' do
    state :pending, initial: true
    state :starting
    state :paused
    state :ended
    state :cancelled

    # Define transitions and callbacks for the state machine
    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, guard: :startable? do
        after do
          decrement_quantity_and_increment_batch
        end
      end
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :can_transition_to_ended? do
        after do
          handle_winner_selection
        end
      end
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  after_update :cancel_all_tickets_if_cancelled
  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true

  def destroy
    update(deleted_at: Time.current)
  end
  def startable?
    quantity.positive? && offline_at.present? && Date.today < offline_at && active?
  end

  private

  # Method to adjust quantity and batch count when item is started
  def decrement_quantity_and_increment_batch
    decrement!(:quantity, 1)
    increment!(:batch_count, 1)
  end

  def cancel_all_tickets_if_cancelled
    if state == 'cancelled'
      tickets.update_all(state: 'cancelled')
    end
  end

  def check_for_associated_tickets
    if tickets.exists?
      errors.add(:base, 'Cannot delete item with associated tickets')
      throw :abort
    end
  end

  # Guard for transitioning to 'ended'
  def can_transition_to_ended?
    tickets.where(batch_count: batch_count).count >= minimum_tickets
  end

  # Logic to handle winner selection
  def handle_winner_selection
    current_batch_tickets = tickets.where(batch_count: batch_count)
    winner_ticket = current_batch_tickets.sample

    if winner_ticket
      winner_ticket.update!(state: 'won')
      current_batch_tickets.where.not(id: winner_ticket.id).update_all(state: 'lost')

      Winner.create!(
        item_id: id,
        ticket_id: winner_ticket.id,
        user_id: winner_ticket.user_id,
        location_id: winner_ticket.user.locations.first&.id,
        admin_id: User.admin.first&.id, # Adjust as per your admin fetching logic
        price: calculate_winner_price,
        state: 'won'
      )
    else
      errors.add(:base, 'No tickets available to pick a winner')
      raise ActiveRecord::Rollback
    end
  end

  # Example method to calculate winner's price (customize as needed)
  def calculate_winner_price
    # Assuming the price is based on some logic; adjust accordingly
    minimum_tickets * 10
  end
end



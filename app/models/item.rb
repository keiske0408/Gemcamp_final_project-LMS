class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  default_scope { where(deleted_at: nil) }

  belongs_to :category
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
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  # AASM for the status lifecycle
  aasm column: 'status' do
    state :draft, initial: true
    state :active
    state :inactive

    event :activate do
      transitions from: [:draft, :inactive], to: :active
    end

    event :deactivate do
      transitions from: [:active], to: :inactive
    end
  end

  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true

  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.batch_count ||= 0
  end

  def startable?
    quantity.positive? && offline_at.present? && Date.today < offline_at && status == 'active'
  end

  private

  # Method to adjust quantity and batch count when item is started
  def decrement_quantity_and_increment_batch
    decrement!(:quantity, 1)
    increment!(:batch_count, 1)
  end

end

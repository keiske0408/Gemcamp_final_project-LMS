class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  default_scope { where(deleted_at: nil) }
  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
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

  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true

  # after_initialize :set_defaults, if: :new_record?

  # def set_defaults
  #   self.batch_count ||= 0
  # end
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

end



class Category < ApplicationRecord
  # Default scope to exclude soft-deleted categories
  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  default_scope { order(:sort) }
  validates :sort, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }

  default_scope { where(deleted_at: nil) }


  def destroy
    if items.exists?
      errors.add(:base, "Cannot delete category with associated items")
      return false
    else
      update(deleted_at: Time.current)
    end
  end

  def deleted?
    deleted_at.present?
  end

  def restore
    update(deleted_at: nil)
  end
end

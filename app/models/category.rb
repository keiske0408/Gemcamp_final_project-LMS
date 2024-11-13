class Category < ApplicationRecord
  # Default scope to exclude soft-deleted categories
  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  default_scope { where(deleted_at: nil) }

  # Soft delete by setting deleted_at instead of deleting the record
  def destroy
    if items.exists?
      errors.add(:base, "Cannot delete category with associated items")
      return false
    else
      update(deleted_at: Time.current)
    end
  end

  # Check if category is soft deleted
  def deleted?
    deleted_at.present?
  end

  # Restore a soft-deleted category
  def restore
    update(deleted_at: nil)
  end



end

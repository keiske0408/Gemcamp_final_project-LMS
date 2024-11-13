class Category < ApplicationRecord
  # Default scope to exclude soft-deleted categories
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

  # Associations (assuming each category has many items)
  has_many :items, dependent: :restrict_with_error

end

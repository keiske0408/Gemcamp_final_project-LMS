class ChangeStatusToEnumInBanners < ActiveRecord::Migration[7.0]
  def up
    change_column :banners, :status, :integer, using: 'status::integer', default: 0
  end

  def down
    change_column :banners, :status, :string
  end
end

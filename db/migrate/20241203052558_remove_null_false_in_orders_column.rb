class RemoveNullFalseInOrdersColumn < ActiveRecord::Migration[7.0]
  def up
    change_column :orders, :offer_id, :bigint, null: true
  end

  def down
    change_column :orders, :offer_id, :bigint, null: false
  end
end

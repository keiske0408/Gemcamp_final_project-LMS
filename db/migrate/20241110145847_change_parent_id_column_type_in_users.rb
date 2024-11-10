class ChangeParentIdColumnTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :parent_id, :bigint, null: true
    add_foreign_key :users, :users, column: :parent_id, primary_key: :id
  end
end

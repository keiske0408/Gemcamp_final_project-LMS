class ChangeParentIdColumnTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :parent_id, :bigint
    add_foreign_key :users, :users, column: :parent_id, primary_key: :id
  end
end

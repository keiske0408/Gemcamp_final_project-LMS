class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.bigint :item_id, null: false, foreign_key: true
      t.bigint :ticket_id, null: false, foreign_key: true
      t.bigint :user_id, null: false, foreign_key: true
      t.bigint :location_id, foreign_key: true
      t.integer :item_batch_count
      t.string :state
      t.decimal :price, precision: 10, scale: 2
      t.datetime :paid_at
      t.bigint :admin_id, foreign_key: { to_table: :users }
      t.string :picture
      t.text :comment

      t.timestamps
    end
    add_foreign_key :winners, :items
    add_foreign_key :winners, :tickets
    add_foreign_key :winners, :users
    add_foreign_key :winners, :locations
    add_foreign_key :winners, :users, column: :admin_id
  end
end

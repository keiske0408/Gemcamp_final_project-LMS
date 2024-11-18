class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :state, default: 0, null: false
      t.string :serial_number, null: false, unique: true
      t.integer :batch_count
      t.integer :coins, default: 1

      t.timestamps
    end
  end
end

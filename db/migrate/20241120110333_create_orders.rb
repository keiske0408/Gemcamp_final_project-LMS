class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true
      t.string :serial_number
      t.string :state
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.integer :coin, default: 0
      t.text :remarks
      t.integer :genre , null: false

      t.timestamps
    end
  end
end

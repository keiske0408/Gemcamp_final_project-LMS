class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :coin, null: false
      t.string :image
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end

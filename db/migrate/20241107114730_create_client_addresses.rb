class CreateClientAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :client_addresses do |t|
      t.integer :genre
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.references :user, null: false, foreign_key: true
      t.references :address_region, null: false, foreign_key: true
      t.references :address_province, null: false, foreign_key: true
      t.references :address_city, null: false, foreign_key: true
      t.references :address_barangay, null: false, foreign_key: true

      t.timestamps
    end
  end
end

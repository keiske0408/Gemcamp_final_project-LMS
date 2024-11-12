class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :quantity
      t.integer :minimum_tickets
      t.integer :batch_count
      t.datetime :online_at
      t.datetime :offline_at
      t.datetime :start_at
      t.string :status
      t.string :image

      t.timestamps
    end
  end
end

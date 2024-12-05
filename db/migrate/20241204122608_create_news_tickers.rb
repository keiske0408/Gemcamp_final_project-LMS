class CreateNewsTickers < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tickers do |t|
      t.text :content
      t.string :status
      t.belongs_to :admin
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

class ChangeStatusToEnumInNewsTickers < ActiveRecord::Migration[7.0]
  def up
    change_column :news_tickers, :status, :integer, using: 'status::integer', default: 0
  end

  def down
    change_column :news_tickers, :status, :string
  end
end

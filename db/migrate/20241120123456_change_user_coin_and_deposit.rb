class ChangeUserCoinAndDeposit < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :coins, :integer, default: 0# Set the column type and default
    change_column :users, :total_deposit, :decimal, precision: 10, scale: 2, default: 0.0  # Set precision, scale, and default
  end

  def down
    change_column :users, :coins, :integer # Revert to previous default and nullability
    change_column :users, :total_deposit, :decimal, precision: 10 # Revert default and scale
  end
end


class AddLevelToUsers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:users, :member_level_id)
      add_reference :users, :member_level, default: nil, foreign_key: true
      end
  end
end

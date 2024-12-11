class AddLevelToUsers < ActiveRecord::Migration[7.0]
  def up
    add_reference :users, :member_level, foreign_key: true
  end

  def down
    remove_reference :users, :member_level, foreign_key: true
  end
end

class SetDefaultBatchCountOnItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :batch_count, from: nil, to: 0
  end
end

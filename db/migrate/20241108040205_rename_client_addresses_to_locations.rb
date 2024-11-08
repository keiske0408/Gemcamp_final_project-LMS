class RenameClientAddressesToLocations < ActiveRecord::Migration[7.0]
  def change
    rename_table :client_addresses, :locations
  end
end

class AddVehicleToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :vehicle, :string
  end
end

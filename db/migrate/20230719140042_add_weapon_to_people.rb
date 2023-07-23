class AddWeaponToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :weapon, :string
  end
end

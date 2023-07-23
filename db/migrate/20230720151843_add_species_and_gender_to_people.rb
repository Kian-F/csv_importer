class AddSpeciesAndGenderToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :species, :string
    add_column :people, :gender, :string
  end
end

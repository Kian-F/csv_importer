class CreateAffiliations < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliations do |t|
      t.string :name
    end
  end
end

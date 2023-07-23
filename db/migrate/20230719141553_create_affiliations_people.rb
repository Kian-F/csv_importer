class CreateAffiliationsPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliations_people do |t|
      t.belongs_to :affiliation
      t.belongs_to :person
    end
  end
end

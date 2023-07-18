require 'csv'

class ImportService
  def self.import_data(file)
    CSV.foreach(file.path, headers: true) do |row|
      person = Person.new(
        first_name: row['Name'].split(' ').first.titlecase,
        last_name: row['Name'].split(' ').last.titlecase,
        weapon: row['Weapon'],
        vehicle: row['Vehicle']
      )

      next unless person.valid?

      person.save

      locations = row['Location'].split(',').map(&:strip)
      locations.each do |location_name|
        location = Location.find_or_create_by(name: location_name.titlecase)
        person.locations << location
      end

      affiliations = row['Affiliations'].split(',').map(&:strip)
      affiliations.each do |affiliation_name|
        next if affiliation_name.blank?

        affiliation = Affiliation.find_or_create_by(name: affiliation_name.titlecase)
        person.affiliations << affiliation
      end
    end
  end
end

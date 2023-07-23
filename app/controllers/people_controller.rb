class PeopleController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def cors_preflight_check
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'

    head :no_content
  end

  def index
    @people = Person.includes(:locations, :affiliations).all

    if params[:string].present?
      search_string = params[:string].strip
      search_operator = ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql') ? 'ILIKE' : 'LIKE'
      @people = @people.where("(first_name || ' ' || last_name) #{search_operator} ?", "%#{search_string}%")
    end

    # Locations
    if params[:locations].present?
      location_names = params[:locations].split(',')
      search_operator = ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql') ? 'ILIKE' : 'LIKE'
      location_conditions = location_names.map { |name| "locations.name #{search_operator} ?" }
      location_conditions = location_conditions.join(' OR ')
      @people = @people.joins(:locations).where(location_conditions, *location_names.map { |name| "%#{name}%" })
    end

    # Species
    if params[:species].present?
      species_names = params[:species].split(',')
      @people = @people.where(species: species_names)
    end

    # weapon
    if params[:weapon].present?
       weapon_names = params[:weapon].split(',')
      @people = @people.where(weapon: weapon_names)
    end

    # Gender
    if params[:gender].present?
      gender_names = params[:gender].split(',')
     @people = @people.where(gender: gender_names)
    end

    # Vehicle
    if params[:vehicle].present?
      vehicle_names = params[:vehicle].split(',')
      @people = @people.where(vehicle: vehicle_names)
    end

    # Affiliations
    if params[:affiliations].present?
      affiliation_names = params[:affiliations].split(',')
      search_operator = ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql') ? 'ILIKE' : 'LIKE'
      affiliation_conditions = affiliation_names.map { |name| "affiliations.name ILIKE :affiliation_#{name}" }
      affiliation_conditions = affiliation_conditions.join(' OR ')
      @people = @people.joins(:affiliations).where(affiliation_conditions, affiliation_names.map { |name| { "affiliation_#{name}".to_sym => "%#{name}%" } })
    end

    render json: @people.to_json(include: [:locations, :affiliations])
  end


  def create
    permitted_params = params.require(:person).map do |person_data|
      person_data.permit(:first_name, :last_name, :species, :gender, :weapon, :vehicle, locations: [], affiliations: [])
    end

    if permitted_params.present?
      permitted_params.each do |person_data|

        person = Person.new(
          first_name: person_data[:first_name],
          last_name: person_data[:last_name],
          species: person_data[:species],
          gender: person_data[:gender],
          weapon: person_data[:weapon],
          vehicle: person_data[:vehicle]
        )

        if person.save
          if person_data[:locations].present?
            person_data[:locations].each do |location_name|
              location = Location.find_or_create_by(name: location_name.strip)
              person.locations << location
            end
          end

          if person_data[:affiliations].present?
            person_data[:affiliations].each do |affiliation_name|
              next if affiliation_name.blank?
              affiliation = Affiliation.find_or_create_by(name: affiliation_name.strip)
              person.affiliations << affiliation
            end
          end
        end
      end

      render json: { message: 'People data successfully saved.' }
    else
      render json: { message: 'No people data found.' }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:string, :locations, :species, :weapon, :gender, :vehicle, :affiliations)
  end
end

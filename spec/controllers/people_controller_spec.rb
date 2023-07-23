require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  config.include FactoryBot::Syntax::Methods

  describe 'GET #index' do
    let!(:location1) { create(:location, name: 'City1') }
    let!(:location2) { create(:location, name: 'City2') }
    let!(:person1) { create(:person, first_name: 'John', last_name: 'Doe', species: 'Human', locations: [location1]) }
    let!(:person2) { create(:person, first_name: 'Mike', last_name: 'Smith', species: 'Human', locations: [location2]) }

    it 'returns a list of people' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to match_array([person1, person2])
    end

    it 'filters people by string' do
      get :index, params: { string: 'John' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1])
    end

    it 'returns people with matching locations' do
      get :index, params: { locations: 'City1' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1])
    end

    it 'returns people with multiple matching locations' do
      get :index, params: { locations: 'City1,City2' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to match_array([person1, person2])
    end

    it 'returns an empty array if no matching location is found' do
      get :index, params: { locations: 'City3' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([])
    end

    it 'filters people by species' do
      get :index, params: { species: 'Human' }

      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1, person2])
    end

    it 'filters people by weapon' do
      get :index, params: { weapon: 'Sword' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1, person2])
    end

    it 'filters people by gender' do
      get :index, params: { gender: 'Male' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1, person2])
    end

    it 'filters people by vehicle' do
      get :index, params: { vehicle: 'Car' }
      expect(response).to have_http_status(:success)
      expect(assigns(:people)).to eq([person1, person2])
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        person: [
          { first_name: 'John', last_name: 'Doe', species: 'Human', gender: 'Male', weapon: 'Sword', vehicle: 'Car', locations: ['City1', 'City2'], affiliations: ['Group1'] },
          { first_name: 'Jane', last_name: 'Smith', species: 'Alien', gender: 'Female', weapon: 'Blaster', vehicle: 'Spaceship', locations: ['City3'], affiliations: ['Group2'] }
        ]
      }
    end

    it 'creates people and their associations' do
      post :create, params: valid_params
      expect(response).to have_http_status(:success)

      expect(Person.count).to eq(2)

      john = Person.find_by(first_name: 'John')

      expect(john.species).to eq('Human')
      expect(john.gender).to eq('Male')
      expect(john.weapon).to eq('Sword')
      expect(john.vehicle).to eq('Car')
      expect(john.locations.pluck(:name)).to match_array(['City1', 'City2'])
      expect(john.affiliations.pluck(:name)).to match_array(['Group1'])
    end

    it 'skips adding blank affiliations' do
      blank_affiliation_params = valid_params.deep_dup
      blank_affiliation_params[:person][0][:affiliations] = ['Group1', '', ' ']

      post :create, params: blank_affiliation_params
      expect(response).to have_http_status(:success)

      expect(Person.count).to eq(2)

      john = Person.find_by(first_name: 'John')
      expect(john.affiliations.pluck(:name)).to match_array(['Group1'])
    end
  end

  describe 'OPTIONS #cors_preflight_check' do
    it 'returns CORS headers for preflight check' do
      process :cors_preflight_check, method: :options
      expect(response).to have_http_status(:no_content)
      expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
      expect(response.headers['Access-Control-Allow-Methods']).to eq('POST, OPTIONS')
      expect(response.headers['Access-Control-Allow-Headers']).to eq('Content-Type')
    end
  end
end
require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  setup do
    @person = FactoryBot.create(:person)
  end

  describe 'GET index' do
    it 'assigns @people' do
      get :index
      expect(assigns(:people)).to eq([@person])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end


# spec/models/person_spec.rb
require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:locations) }
    it { should have_and_belong_to_many(:affiliations) }
  end
end

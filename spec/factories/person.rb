# spec/factories/people.rb
FactoryBot.define do
  factory :person do
    first_name { 'John' }
    last_name { 'Doe' }
    species { 'Human' }
    gender { 'Male' }
    weapon { 'Sword' }
    vehicle { 'Car' }

    trait :with_locations do
      after(:create) do |person|
        person.locations << create(:location, name: 'City1')
        person.locations << create(:location, name: 'City2')
      end
    end

    trait :with_affiliations do
      after(:create) do |person|
        person.affiliations << create(:affiliation, name: 'Group1')
      end
    end
  end
end

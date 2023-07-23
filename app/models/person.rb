class Person < ApplicationRecord
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :affiliations

  validates :first_name, presence: true
  validates :last_name, presence: true, allow_blank: true
  validates :weapon, presence: true, allow_blank: true
  validates :vehicle, presence: true, allow_blank: true
  validates :species, presence: true
  validates :gender, presence: true
end

# app/models/listing_pet.rb
class ListingPet < ApplicationRecord
  belongs_to :listing
  belongs_to :pet
end

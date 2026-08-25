# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "cleaning database..."

AlertResponse.destroy_all
AmberAlert.destroy_all
Rsvp.destroy_all
Event.destroy_all
Offer.destroy_all
ListingPet.destroy_all
Listing.destroy_all
Connection.destroy_all
Pet.destroy_all
User.destroy_all

puts "Database cleaned."

puts "Creating users..."

PASSWORD = "password"

tom = User.create!(
  name: "Tom",
  email: "tom@example.com",
  password: PASSWORD,
  mobile: "0412 334 981",
  location: "Sydney, NSW",
  latitude: -33.8688,
  longitude: 151.2093,
  profile_pic: "https://placehold.co/400x400?text=Tom"
)
puts "added user #{tom.name} into database"
tom.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/tom.jpg")),
  filename: "tom.jpg",
  content_type: "image/jpg"
)
sam = User.create!(
  name: "Sam",
  email: "sam@example.com",
  password: PASSWORD,
  mobile: "0433 210 776",
  location: "Newtown, NSW",
  latitude: -33.8978,
  longitude: 151.1797,
  profile_pic: "https://placehold.co/400x400?text=Sam"
)
sam.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/sam.jpg")),
  filename: "sam.jpg",
  content_type: "image/jpg"
)
puts "added user #{sam.name} into database"

priya = User.create!(
  name: "Priya",
  email: "priya@example.com",
  password: PASSWORD,
  mobile: "0455 909 112",
  location: "Surry Hills, NSW",
  latitude: -33.8848,
  longitude: 151.2131,
  profile_pic: "https://placehold.co/400x400?text=Priya"
)
priya.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/priya.jpg")),
  filename: "priya.jpg",
  content_type: "image/jpg"
)
puts "added user #{priya.name} into database"

jerry = User.create!(
  name: "Jerry",
  email: "jerry@example.com",
  password: PASSWORD,
  mobile: "0401 887 334",
  location: "Alexandria, NSW",
  latitude: -33.9092,
  longitude: 151.1941,
  profile_pic: "https://placehold.co/400x400?text=Jerry"
)
jerry.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/jerry.jpg")),
  filename: "jerry.jpg",
  content_type: "image/jpg"
)
puts "added user #{jerry.name} into database"

emma = User.create!(
  name: "Emma",
  email: "emma@example.com",
  password: PASSWORD,
  mobile: "0466 445 220",
  location: "Coogee, NSW",
  latitude: -33.9205,
  longitude: 151.2552,
  profile_pic: nil
)
puts "added user #{emma.name} into database (no profile picture)"

puts "#{User.count} users created."


puts "Creating pets..."

neo= Pet.create!(
  user: tom,
  name: "Neo",
  species: "Cat",
  age: 4,
  care_instructions: "Ginger tabby, very shy. Hides under the bed for the first hour — " \
                    "do not chase him, he comes out for tuna. Two meals a day, 7am and 6pm. " \
                    "Wet food in the blue bowl only, he refuses the green one.",
  profile_pic: "https://placehold.co/600x600?text=Neo"
)
neo.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/neo.jpg")),
  filename: "neo.jpg",
  content_type: "image/jpg"
)
puts "added pet #{neo.name} (#{neo.species}) for #{tom.name} into database"

dumpling = Pet.create!(
  user: tom,
  name: "Dumpling",
  species: "Cat",
  age: 2,
  care_instructions: "Neo's sister. Confident, will demand attention immediately. " \
                    "Allergic to chicken — check the label.",
  profile_pic: "https://placehold.co/600x600?text=Dumpling"
)
dumpling.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/dumpling.jpg")),
  filename: "dumpling.jpg",
  content_type: "image/jpg"
)
puts "added pet #{dumpling.name} (#{dumpling.species}) for #{tom.name} into database."

biscuit = Pet.create!(
  user: sam,
  name: "Biscuit",
  species: "Dog",
  age: 7,
  care_instructions: "Golden retriever, older girl with a sore hip. Short walks only, " \
                    "20 minutes max. Pulls hard when she sees other dogs. " \
                    "Medication in the fridge door, half a tablet with breakfast.",
  profile_pic: "https://placehold.co/600x600?text=Biscuit"
)
biscuit.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/biscuit.jpg")),
  filename: "biscuit.jpg",
  content_type: "image/jpg"
)
puts "added pet #{biscuit.name} (#{biscuit.species}) for #{sam.name} into database"

kiwi = Pet.create!(
  user: priya,
  name: "Kiwi",
  species: "Bird",
  age: 1,
  care_instructions: "Budgie. Cover the cage at 8pm or he will not shut up. " \
                    "Fresh water daily, seed top-up every second day.",
  profile_pic: "https://placehold.co/600x600?text=Kiwi"
)
kiwi.avatar.attach(
  io: File.open(Rails.root.join("db/seeds/images/kiwi.jpg")),
  filename: "kiwi.jpg",
  content_type: "image/jpg"
)
puts "added pet #{kiwi.name} (#{kiwi.species}) for #{priya.name} into database"

puts "#{Pet.count} pets created.\n\n"


puts "Creating listings..."

# Scenario 1: the main demo listing. Attracts several offers, one gets accepted.
both_cats = Listing.create!(
  owner: tom,
  pets: [neo, dumpling],
  listing_type: "Sitting",
  start_date: Date.current + 5,
  end_date: Date.current + 8,
  listing_note: "House sitting for Neo and Dumpling for a few days. "
)
puts "added #{both_cats.listing_type} for #{both_cats.pets.map(&:name).to_sentence} (LIVE — demo click)"


# Scenario 2: a brand new post with no offers yet.

kiwi_dropin = Listing.create!(
  owner: priya,
  pets: [kiwi],
  listing_type: "Drop-in",
  start_date: Date.current + 12,
  end_date: Date.current + 13,
  listing_note: "Seed and water top-up once a day."
)
puts "added #{kiwi_dropin.listing_type} for #{kiwi.name} (no offers)"


# Scenario 3: a listing whose dates have already passed.
past_sit = Listing.create!(
  owner: tom,
  pets: [neo, dumpling],
  listing_type: "Drop-in",
  start_date: Date.current - 21,
  end_date: Date.current - 20,
  listing_note: "Overnight trip, just needed food and water checked."
)
puts "added #{past_sit.listing_type} for #{past_sit.pets.map(&:name).to_sentence} (completed)"

biscuit_walk_past = Listing.create!(
  owner: sam,
  pets: [biscuit],
  listing_type: "Walking",
  start_date: Date.current - 10,
  end_date: Date.current - 9,
  listing_note: "Needed a hand in the morning for gentle walk 20 minutes."
)
puts "added listing #{biscuit_walk_past.listing_type} for #{biscuit.name} into database (expired)"

biscuit_walk = Listing.create!(
  owner: sam,
  pets: [biscuit],
  listing_type: "Walking",
  start_date: Date.current + 1,
  end_date: Date.current + 14,
  listing_note: "Weekday morning walks, 20 minutes, gentle pace. Ongoing if it works out."
)
puts "added listing #{biscuit_walk.listing_type} for #{biscuit.name} into database"

puts "#{Listing.count} listings created.\n\n"


puts "Creating offers..."

# Past journey — resolved
Offer.create!(listing: past_sit, user: sam, status: "accepted")
puts "#{sam.name} was accepted on the past drop-in"

# LIVE listing — three pending offers, three different trust positions.
{ sam   => "already connected to Tom",
  priya => "one mutual connection",
  jerry => "no connections — new neighbour" }.each do |sitter, why|
  Offer.create!(listing: both_cats, user: sitter, status: "offered")
  puts "#{sitter.name} offered on #{both_cats.pets.map(&:name).to_sentence}  [#{why}]"
end

Offer.create!(listing: biscuit_walk, user: priya, status: "offered")
puts "#{priya.name} offered on #{biscuit.name}'s walk"

puts "#{Offer.count} offers created."

puts "Creating connections..."

Connection.create!(sender: tom,   receiver: sam)
Connection.create!(sender: sam,   receiver: priya)
Connection.create!(sender: tom,   receiver: priya)
Connection.create!(sender: priya, receiver: emma)

puts "#{Connection.count} connections created."


puts "Seeding complete."
puts "  Users: #{User.count}"
puts "  Pets: #{Pet.count}"
puts "  Listings: #{Listing.count}"
puts "  Offers: #{Offer.count}"
puts "  Connections: #{Connection.count}"
puts "Log in with any seeded email and the password: #{PASSWORD}"
puts "e.g. tom@example.com (owner)  /  sam@example.com (sitter)"

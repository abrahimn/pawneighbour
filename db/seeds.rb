# frozen_string_literal: true

# A deliberately colourful, deterministic demo dataset spread across Greater Sydney.
# Run with: bin/rails db:seed

puts "Cleaning database..."

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

PASSWORD = "password"

people = [
  ["Luna",   "Newtown",      -33.8978, 151.1797],
  ["Abe",    "Newtown",      -33.8955, 151.1830],
  ["Priya",  "Camperdown",   -33.8891, 151.1770],
  ["Jerry",  "Surry Hills",  -33.8848, 151.2131],
  ["Emma",   "Coogee",       -33.9205, 151.2552],
  ["Ziggy",  "Bondi Beach",  -33.8908, 151.2743],
  ["Nina",   "Manly",        -33.7969, 151.2840],
  ["Baz",    "Sydney CBD",   -33.8701, 151.2075],
  ["Mei",    "Glebe",        -33.8796, 151.1874],
  ["Hugo",   "Marrickville", -33.9106, 151.1550],
  ["Aisha",  "Lakemba",      -33.9190, 151.0759],
  ["Finn",   "Balmain",      -33.8570, 151.1810],
  ["Val",    "Cronulla",     -34.0551, 151.1517],
  ["Nico",   "Leichhardt",   -33.8835, 151.1574],
  ["Ruby",   "Mosman",       -33.8290, 151.2441],
  ["Dev",    "Strathfield",  -33.8732, 151.0931],
  ["Tahlia", "Blacktown",    -33.7688, 150.9063],
  ["Ollie",  "Penrith",      -33.7511, 150.6942],
  ["Grace",  "Ryde",         -33.8151, 151.1018],
  ["Macca",  "Redfern",      -33.8932, 151.2047],
  ["Sofia",  "Paddington",   -33.8846, 151.2262],
  ["Noah",   "Lane Cove",    -33.8153, 151.1668],
  ["Imani",  "Burwood",      -33.8774, 151.1035],
  ["Theo",   "Bankstown",    -33.9173, 151.0349],
  ["Lulu",   "Dee Why",      -33.7511, 151.2881],
  ["Ravi",   "Liverpool",    -33.9209, 150.9239],
  ["Josie",  "Kogarah",      -33.9667, 151.1333],
  ["Kenji",  "Epping",       -33.7724, 151.0824],
  ["Billie", "Glebe",        -33.8800, 151.1870],
  ["Mo",     "Castle Hill",  -33.7315, 151.0064],
  ["Ana",    "Neutral Bay",  -33.8310, 151.2190],
  ["Wes",    "Botany",       -33.9450, 151.1960]
]

puts "Creating #{people.length} neighbours across Sydney..."

users = people.each_with_index.map do |(name, suburb, latitude, longitude), index|
  user = User.create!(
    name: name,
    email: "#{name.downcase}@example.com",
    password: PASSWORD,
    mobile: format("04%08d", 12_340_000 + index),
    location: "#{suburb}, NSW",
    latitude: latitude,
    longitude: longitude,
    profile_pic: "https://placehold.co/400x400?text=#{name}"
  )
  filename = "#{name.parameterize}.jpg"
  user.avatar.attach(
    io: File.open(Rails.root.join("db/seeds/images/unsplash/users", filename)),
    filename: filename,
    content_type: "image/jpeg"
  )
  user
end.index_by(&:name)

luna  = users.fetch("Luna")
abe   = users.fetch("Abe")
priya = users.fetch("Priya")

puts "#{User.count} users created.\n\n"

# ---------------------------------------------------------------------------
# PETS
# ---------------------------------------------------------------------------
pet_data = [
  ["Luna", "Neo", "Cat", 4, "neo.jpg",
  "Ginger tabby, very shy. Hides under the bed for the first hour - do not chase him, " \
  "he comes out for tuna. Two meals a day, 7am and 6pm. Wet food in the blue bowl only."],
  ["Luna", "Dumpling", "Cat", 2, "dumpling.jpg",
  "Neo's sister and his opposite. Will demand attention immediately. " \
  "Allergic to chicken - please check the label."],
  ["Abe", "Biscuit", "Dog", 7, "biscuit.jpg",
  "Golden retriever, older girl with a sore hip. Short walks only, 20 minutes max. " \
  "Half a tablet with breakfast, medication in the fridge door."],
  ["Priya", "Kiwi", "Bird", 1, "kiwi.jpg",
  "Budgie. Cover the cage at 8pm or he will not shut up. Knows three words; " \
  "two are mildly embarrassing."],
  ["Mei", "Mochi", "Dog", 3, "mochi.jpg",
  "Shiba Inu and a committed escape artist. The harness must click twice before " \
  "the front door opens."],
  ["Jerry", "Gnocchi", "Dog", 7, "gnocchi.jpg",
  "Pug. Breathes like a small tractor. Short walks, and never in the midday heat."],
  ["Noah", "Schnitzel", "Dog", 5, "schnitzel.jpg",
  "Dachshund. No stairs, no puddles, and no criticism of his very long torso."],
  ["Kenji", "Waffles", "Dog", 4, "waffles.jpg",
  "Corgi, built low to the ground for aerodynamic snack retrieval. One sensible walk, then sofa."],
  ["Lulu", "Pickles", "Dog", 9, "pickles.jpg",
  "Gentle old soul. Carries one sock on every walk, for confidence."],
  ["Theo", "Gandalf", "Cat", 12, "gandalf.jpg",
  "You shall not pass the hallway without administering chin scratches."],
  ["Billie", "Kevin Bacon", "Guinea Pig", 3, "kevin-bacon.jpg",
  "One capsicum slice at lunch. Wheeks like a tiny car alarm when the fridge opens."],
  ["Ravi", "Toast", "Dog", 4, "toast.jpg",
  "Loves people, buses, and dramatically failing to catch tennis balls."]
]

pets = pet_data.map do |owner_name, name, species, age, image, instructions|
  pet = Pet.create!(
    user: users.fetch(owner_name),
    name: name,
    species: species,
    age: age,
    care_instructions: instructions
  )
  pet.avatar.attach(
    io: File.open(Rails.root.join("db/seeds/images/unsplash", image)),
    filename: image,
    content_type: "image/jpeg"
  )
  pet
end.index_by(&:name)

dumpling = pets.fetch("Dumpling")
biscuit  = pets.fetch("Biscuit")
kiwi     = pets.fetch("Kiwi")

puts "#{Pet.count} pets created.\n\n"

# ---------------------------------------------------------------------------
# CONNECTIONS - built BEFORE the offers so the trust bands are already true
# ---------------------------------------------------------------------------
# Luna and Abe are not directly connected, but share Jerry and Mei as mutuals.
# Luna and Priya do NOT know each other. Abe and Jerry know Priya.
puts "Creating connections..."
[
  %w[Luna  Jerry],
  %w[Luna  Mei],
  %w[Priya Abe],
  %w[Priya Jerry],
  %w[Abe   Jerry],   # they helped each other
  %w[Mei   Abe],
  %w[Mei   Noah],
  %w[Abe   Billie],
  %w[Imani Kenji],
  %w[Grace Lulu],
  %w[Theo  Ravi],
  %w[Lulu  Emma]
].each do |a, b|
  Connection.create!(sender: users.fetch(a), receiver: users.fetch(b))
  puts "  #{a} <-> #{b}"
end
puts "#{Connection.count} connections.\n\n"

# ---------------------------------------------------------------------------
# JOURNEY A - completed three weeks ago (history)
# ---------------------------------------------------------------------------
past_dropin = Listing.create!(
  owner: luna,
  pets: [dumpling],
  listing_type: "Drop-in",
  start_date: Date.current - 21,
  end_date: Date.current - 20,
  listing_note: "Overnight trip - just needed food and water checked."
)
Offer.create!(listing: past_dropin, user: abe, status: "accepted")
puts "Journey A: Luna posted 3 weeks ago, Abe was accepted.\n\n"

# ---------------------------------------------------------------------------
# THE BOARD
# ---------------------------------------------------------------------------
board = [
  ["Abe",    ["Biscuit"],     "Walking", 1, 14,
  "Weekday morning walks, 20 minutes, gentle pace. Ongoing if it works out."],
  ["Mei",    ["Mochi"],       "Walking", 3, 6,
  "A calm walker who understands that sniffing one pole for six minutes is enrichment."],
  ["Jerry",  ["Gnocchi"],     "Sitting", 2, 9,
  "Staying over would be ideal. He hates being alone overnight."],
  ["Noah",   ["Schnitzel"],   "Walking", 6, 10,
  "Short flat route please. He will attempt stairs out of pride; do not let him."],
  ["Kenji",  ["Waffles"],     "Walking", 2, 5,
  "A proper walk, then he'll sleep for nine hours. Treats in the tin by the door."],
  ["Lulu",   ["Pickles"],     "Sitting", 8, 11,
  "House-sit and enjoy the wifi. He may join your video calls as regional manager."],
  ["Theo",   ["Gandalf"],     "Drop-in", 3, 5,
  "Feed him and then sit down. That's the whole job. He'll take it from there."],
  ["Ravi",   ["Toast"],       "Walking", 7, 12,
  "Any route with a bus stop on it. He likes to supervise the timetable."],
  ["Billie", ["Kevin Bacon"], "Drop-in", 9, 12,
  "Capsicum at lunch, hay topped up, and one round of applause for the wheeking."]
]

board.each do |owner_name, pet_names, type, from, to, note|
  owner = users.fetch(owner_name)
  Listing.create!(
    owner: owner,
    pets: pet_names.map { |n| pets.fetch(n) },
    listing_type: type,
    start_date: Date.current + from,
    end_date: Date.current + to,
    listing_note: note
  )
  puts "  #{owner_name} (#{owner.location.split(',').first}): #{type} for #{pet_names.to_sentence}"
end
puts

# ---------------------------------------------------------------------------
# EDGE CASES
# ---------------------------------------------------------------------------
Listing.create!(
  owner: priya,
  pets: [kiwi],
  listing_type: "Drop-in",
  start_date: Date.current + 12,
  end_date: Date.current + 13,
  listing_note: "Seed and water top-up once a day."
)
puts "Kiwi's Drop-in - ZERO offers (empty state)"

Listing.create!(
  owner: abe,
  pets: [biscuit],
  listing_type: "Walking",
  start_date: Date.current - 10,
  end_date: Date.current - 9,
  listing_note: "Needed a hand while I was at a conference."
)
puts "Biscuit's Walking - dates PASSED (should not appear on the board)"

abes_walk = Listing.find_by(user_id: abe.id, start_date: Date.current + 1)
Offer.create!(listing: abes_walk, user: priya, status: "offered")
puts "Priya offered on Biscuit's walk (so Abe has something to review too)\n\n"

puts "Creating community events..."

event_data = [
  ["Inner West Bark & Bake", "Camperdown Memorial Rest Park", "Abe",
   6, "09:30", "Coffee, dogs, and one questionable slice each. Bring water and a lead."],
  ["Tiny Pet, Huge Personality Meetup", "Sydney Park", "Priya",
   11, "14:00", "Guinea pigs, budgies, rabbits and anyone under 5kg with strong opinions."],
  ["Senior Pets Slow Stroll", "Glebe Foreshore", "Mei",
   18, "16:00", "A gentle loop at the pace of the slowest attendee. Benches every 200m."],
  ["Questionable Pet Tricks Showcase", "Prince Alfred Park", "Jerry",
   25, "15:00", "Bring your pet's most needlessly dramatic party trick. No judging, some laughing."]
]

rsvp_lists = [
  %w[Luna Priya Mei Billie],
  %w[Luna Abe Ravi],
  %w[Abe Jerry Billie Noah],
  %w[Luna Priya Mei Kenji Ravi]
]

event_data.each_with_index do |(name, location, organiser_name, days, time, details), index|
  event = Event.create!(
    organiser: users.fetch(organiser_name),
    name: name,
    location: "#{location}, NSW",
    date: Date.current + days,
    time: time,
    details: details,
    photo_url: "https://placehold.co/1200x630?text=#{ERB::Util.url_encode(name)}"
  )
  puts "  #{name} - #{organiser_name}, #{event.date}"

  rsvp_lists[index].each_with_index do |responder_name, i|
    next if responder_name == organiser_name

    Rsvp.create!(
      event: event,
      responder: users.fetch(responder_name),
      response: i.zero? ? "maybe" : "going"
    )
  end
end

puts "#{Event.count} events, #{Rsvp.count} RSVPs.\n\n"

# ---------------------------------------------------------------------------
# AMBER ALERTS + SIGHTINGS
# ---------------------------------------------------------------------------
puts "Creating lost-pet alerts..."

alert_data = [
  ["Mochi", "Glebe, NSW", 0, "17:40",
   [["Luna", "Enmore Road near the pub", "Ran past heading east, wouldn't stop.", "18:05"],
    ["Abe",  "Simmons Street",           "Pretty sure it was her — responded to a snack packet.", "18:40"]]],

  ["Gandalf", "Bankstown Library, NSW", 1, "08:15",
   [["Ravi", "Beside the carpark hedge", "Grey cat, very unbothered. Sitting in the sun.", "09:20"]]]
]

alert_data.each do |pet_name, location, days_ago, time, sightings|
  pet = pets.fetch(pet_name)

  alert = AmberAlert.create!(
    creator: pet.user,
    pet: pet,
    location: location,
    date: Date.current - days_ago,
    time: time
  )
  puts "  #{pet.name} missing from #{location} (#{pet.user.name})"

  sightings.each do |spotter_name, spot_location, notes, spot_time|
    AlertResponse.create!(
      amber_alert: alert,
      spotter: users.fetch(spotter_name),
      location: spot_location,
      date: Date.current,
      time: spot_time,
      notes: notes
    )
    puts "    sighting by #{spotter_name}: #{spot_location}"
  end
end

puts "#{AmberAlert.count} alerts, #{AlertResponse.count} sightings.\n\n"

puts <<~SUMMARY

  Seeding complete — Sydney is now crawling with excellent weirdos.
    Users:           #{User.count}
    Pets:            #{Pet.count}
    Listings:        #{Listing.count}
    Offers:          #{Offer.count}
    Connections:     #{Connection.count}
    Events:          #{Event.count}
    RSVPs:           #{Rsvp.count}
    Amber alerts:    #{AmberAlert.count}
    Alert responses: #{AlertResponse.count}

  Log in with any seeded email and: #{PASSWORD}
  Try luna@example.com, abe@example.com, nina@example.com or baz@example.com.
SUMMARY

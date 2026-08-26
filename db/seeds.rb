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

password = "password"

people = [
  ["Tom", "Newtown", -33.8978, 151.1797],
  ["Sam", "Newtown", -33.8978, 151.1797],
  ["Priya", "Surry Hills", -33.8848, 151.2131],
  ["Jerry", "Surry Hills", -33.8848, 151.2131],
  ["Emma", "Coogee", -33.9205, 151.2552],
  ["Ziggy", "Bondi Beach", -33.8908, 151.2743],
  ["Nina", "Manly", -33.7969, 151.2840],
  ["Baz", "Sydney CBD", -33.8701, 151.2075],
  ["Mei", "Chatswood", -33.7969, 151.1833],
  ["Hugo", "Marrickville", -33.9106, 151.1550],
  ["Aisha", "Lakemba", -33.9190, 151.0759],
  ["Finn", "Balmain", -33.8570, 151.1810],
  ["Val", "Cronulla", -34.0551, 151.1517],
  ["Nico", "Leichhardt", -33.8835, 151.1574],
  ["Ruby", "Mosman", -33.8290, 151.2441],
  ["Dev", "Strathfield", -33.8732, 151.0931],
  ["Tahlia", "Blacktown", -33.7688, 150.9063],
  ["Ollie", "Penrith", -33.7511, 150.6942],
  ["Grace", "Ryde", -33.8151, 151.1018],
  ["Macca", "Redfern", -33.8932, 151.2047],
  ["Sofia", "Paddington", -33.8846, 151.2262],
  ["Noah", "Lane Cove", -33.8153, 151.1668],
  ["Imani", "Burwood", -33.8774, 151.1035],
  ["Theo", "Bankstown", -33.9173, 151.0349],
  ["Lulu", "Dee Why", -33.7511, 151.2881],
  ["Ravi", "Liverpool", -33.9209, 150.9239],
  ["Josie", "Kogarah", -33.9667, 151.1333],
  ["Kenji", "Epping", -33.7724, 151.0824],
  ["Billie", "Glebe", -33.8800, 151.1870],
  ["Mo", "Castle Hill", -33.7315, 151.0064],
  ["Ana", "Neutral Bay", -33.8310, 151.2190],
  ["Wes", "Botany", -33.9450, 151.1960]
]

puts "Creating #{people.length} neighbours across Sydney..."

users = people.each_with_index.map do |(name, suburb, latitude, longitude), index|
  User.create!(
    name: name,
    email: "#{name.downcase}@example.com",
    password: password,
    mobile: format("04%08d", 12_340_000 + index),
    location: "#{suburb}, NSW",
    latitude: latitude,
    longitude: longitude,
    profile_pic: "https://placehold.co/400x400?text=#{name}"
  )
end

users.each do |user|
  filename = "#{user.name.parameterize}.jpg"
  user.avatar.attach(
    io: File.open(Rails.root.join("db/seeds/images/unsplash/users", filename)),
    filename: filename,
    content_type: "image/jpeg"
  )
end

tom   = users["Tom"]
sam   = users["Sam"]
priya = users["Priya"]
jerry = users["Jerry"]

puts "Creating #{User.count} users."

pet_data = [
  ["Tom", "Neo", "Cat", 4, "neo.jpg",
  "Ginger tabby, very shy. Hides under the bed for the first hour - do not chase him, " \
  "he comes out for tuna. Two meals a day, 7am and 6pm. Wet food in the blue bowl only."],

  ["Tom", "Dumpling", "Cat", 2, "dumpling.jpg",
  "Neo's sister and his opposite. Will demand attention immediately. " \
  "Allergic to chicken - please check the label."],

  ["Sam", "Biscuit", "Dog", 7, "biscuit.jpg",
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


pet_data.each do |owner_name, name, species, age, image, instructions|
  Pet.create!(
    user: users.fetch(owner_name),
    name: name,
    species: species,
    age: age,
    care_instructions: instructions
  )
end


pets.each do |pet|
  filename = "#{pet.name.parameterize}.jpg"
  pet.avatar.attach(
    io: File.open(Rails.root.join("db/seeds/images/unsplash", filename)),
    filename: filename,
    content_type: "image/jpeg"
  )
end

neo      = pets["Neo"]
dumpling = pets["Dumpling"]
biscuit  = pets["Biscuit"]
kiwi     = pets["Kiwi"]

puts "Creating #{Pet.count} pets."

past_dropin = Listing.create!(
  owner: tom,
  pets: [dumpling],
  listing_type: "Drop-in",
  start_date: Date.current - 21,
  end_date: Date.current - 20,
  listing_note: "Overnight trip - just needed food and water checked."
)
Offer.create!(listing: past_dropin, user: sam, status: "accepted")
Connection.create!(sender: tom, receiver: sam)
puts "3 weeks ago: Tom posted, Sam was accepted, they are now connected"

both_cats = Listing.create!(
  owner: tom,
  pets: [neo, dumpling],
  listing_type: "Sitting",
  start_date: Date.current + 5,
  end_date: Date.current + 8,
  listing_note: "Away for a long weekend. Neo and Dumpling both need feeding twice a day. " \
                "Neo is shy but easy once he trusts you."
)
puts "Tom posted: Sitting for Neo and Dumpling, #{both_cats.start_date} to #{both_cats.end_date}"

{
  sam   => "directly connected to Tom   -> \"You're connected\"",
  priya => "knows Sam, who knows Tom    -> \"1 mutual connection\"",
  jerry => "no path to Tom at all       -> \"New neighbour\""
}.each do |sitter, why|
  Offer.create!(listing: both_cats, user: sitter, status: "offered")
  puts "#{sitter.name} offered  [#{why}]"
end
puts "  !! No accepted offer here on purpose.\n\n"

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
  owner: sam,
  pets: [biscuit],
  listing_type: "Walking",
  start_date: Date.current - 10,
  end_date: Date.current - 9,
  listing_note: "Needed a hand while I was at a conference."
)
puts "Biscuit's Walking - dates PASSED (should not appear on the board)"

sams_walk = Listing.find_by(user_id: sam.id, start_date: Date.current + 1)
Offer.create!(listing: sams_walk, user: priya, status: "offered")
puts "Priya offered on Biscuit's walk (so Sam has something to review too)"

puts "\n#{Listing.count} listings, #{Offer.count} offers.\n\n"

board = [
  ["Sam",   ["Biscuit"],            "Walking",  1, 14,
  "Weekday morning walks, 20 minutes, gentle pace. Ongoing if it works out."],
  ["Mei",   ["Gnocchi"],            "Sitting",  3,  6,
  "Staying over would be ideal. She hates being alone overnight."],
  ["Jerry", ["Mochi"],              "Walking",  2,  9,
  "Looking for a calm walker who understands that sniffing one pole for six minutes is enrichment."],
  ["Noah",  ["Schnitzel"],          "Walking",  6, 10,
  "Short flat route please. He will attempt stairs out of pride; do not let him."],
  ["Kenji", ["Waffles"],            "Walking",  2,  5,
  "A proper walk, then he'll sleep for nine hours. Treats in the tin by the door."],
  ["Lulu",  ["Pickles"],            "Sitting",  8, 11,
  "House-sit and enjoy the wifi. He may join your video calls as regional manager."],
  ["Theo",  ["Gandalf"],            "Drop-in",  3,  5,
  "Feed him and then sit down. That's the whole job. He'll take it from there."],
  ["Ravi",  ["Toast"],              "Walking",  7, 12,
  "Any route with a bus stop on it. He likes to supervise the timetable."],
  ["Billie", ["Kevin Bacon"],       "Drop-in",  9, 12,
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
  puts "#{owner_name} (#{owner.location.split(',').first}): #{type} for #{pet_names.to_sentence}"
end

puts "CONNECTIONS - the graph the trust band reads"
[
  %w[Sam Priya],
  %w[Sam Billie],
  %w[Mei Noah],
  %w[Mei Billie],
  %w[Imani Kenji],
  %w[Grace Lulu],
  %w[Theo Ravi],
  %w[Lulu Emma]
].each do |a, b|
  Connection.create!(sender: users.fetch(a), receiver: users.fetch(b))
  say "#{a} <-> #{b}"
end

puts "#{Connection.count} connections.\n\n"

event_data = [
  ["Greyhound Speed-Dating (For Friendship)", "Centennial Park", 4, 10, 0],
  ["Dogs Who Think They Are Lap Dogs Picnic", "Bicentennial Park", 7, 11, 30],
  ["Inner West Bark & Bake", "Camperdown Memorial Rest Park", 10, 9, 30],
  ["Tiny Pet, Huge Personality Meetup", "Sydney Park", 13, 14, 0],
  ["Northern Beaches Sandy Snoots", "Manly Lagoon", 17, 8, 0],
  ["Parramatta Paws & Pour-Overs", "Parramatta Park", 21, 10, 30],
  ["Senior Pets Slow Stroll", "Glebe Foreshore", 25, 16, 0],
  ["Questionable Pet Tricks Showcase", "Prince Alfred Park", 29, 15, 0]
]

puts "Creating community events and RSVPs..."

event_data.each_with_index do |(name, location, days, hour, minute), index|
  event = Event.create!(
    organiser: users[index * 3],
    name: name,
    location: "#{location}, NSW",
    date: Date.current + days,
    time: Time.zone.local(Date.current.year, Date.current.month, Date.current.day, hour, minute),
    details: "Bring water, treats and your pet's most needlessly dramatic story.",
    photo_url: "https://placehold.co/1200x630?text=#{ERB::Util.url_encode(name)}"
  )

  users.rotate(index * 4).first(6).each_with_index do |responder, response_index|
    next if responder == event.organiser

    Rsvp.create!(event: event, responder: responder, response: response_index == 5 ? "maybe" : "going")
  end
end

puts "Creating a couple of hopeful lost-pet alerts..."

alert_specs = [
  [pets[8], "Enmore Park, NSW", 0, 17, 40],
  [pets[21], "Lane Cove Plaza, NSW", 1, 8, 15],
  [pets[27], "Epping Station, NSW", 2, 18, 5]
]

alert_specs.each_with_index do |(pet, location, days_ago, hour, minute), index|
  alert = AmberAlert.create!(
    creator: pet.user,
    pet: pet,
    location: location,
    date: Date.current - days_ago,
    time: Time.zone.local(Date.current.year, Date.current.month, Date.current.day, hour, minute)
  )

  2.times do |response_index|
    spotter = users[((index * 8) + response_index + 4) % users.length]
    AlertResponse.create!(
      amber_alert: alert,
      spotter: spotter,
      location: ["near the oval", "beside a suspiciously interesting hedge"][response_index],
      date: Date.current,
      time: Time.zone.now - (response_index + 1).hours,
      notes: [
        "Spotted briefly; heading east with purpose.",
        "Looked similar and responded to a snack packet."
      ][response_index]
    )
  end
end

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

  Log in with any seeded email and: #{password}
  Try tom@example.com, sam@example.com, nina@example.com or baz@example.com.
SUMMARY

# frozen_string_literal: true

# A deliberately colourful, deterministic demo dataset spread across Greater Sydney.
# Run with: bin/rails db:seed

puts "Cleaning database..."

AlertResponse.destroy_all
AmberAlert.destroy_all
Rsvp.destroy_all
Event.destroy_all
Offer.destroy_all
Listing.destroy_all
Connection.destroy_all
Pet.destroy_all
User.destroy_all

puts "Database cleaned."

password = "password"

people = [
  ["Tom", "Sydney CBD", -33.8688, 151.2093],
  ["Sam", "Newtown", -33.8978, 151.1797],
  ["Priya", "Surry Hills", -33.8848, 151.2131],
  ["Jerry", "Alexandria", -33.9092, 151.1941],
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

pet_data = [
  ["Neo", "Cat", 4, "Approach slowly. Accepts tuna as both snack and formal apology."],
  ["Biscuit", "Dog", 7, "Short walks only. Will sit down if the route does not include a cafe."],
  ["Kiwi", "Bird", 1, "Cover the cage at 8pm. Knows three words; two are mildly embarrassing."],
  ["Dumpling", "Cat", 2, "Allergic to chicken. Believes every cardboard box is sovereign territory."],
  ["Kevin Bacon", "Guinea Pig", 3, "One capsicum slice at lunch. Wheeks like a tiny car alarm."],
  ["Schnitzel", "Dachshund", 5, "No stairs, no puddles, no criticism of his very long torso."],
  ["Chairman Meow", "Cat", 8, "Requires the sunny cushion and acknowledgement of his authority."],
  ["Barry Hoppins", "Rabbit", 2, "Parsley after breakfast. Cables must be hidden from his legal team."],
  ["Toast", "Dog", 4, "Loves people, buses and dramatically failing to catch tennis balls."],
  ["Miso", "Cat", 6, "Indoor cat. Opens cupboards and denies everything."],
  ["Disco", "Cockatiel", 9, "Whistles the Bunnings jingle whenever someone enters the room."],
  ["Noodle", "Greyhound", 5, "Two zoomies, then approximately twenty-two hours of sofa."],
  ["Prawn", "Dog", 3, "Rinse sandy paws after the beach. Terrified of decorative flamingos."],
  ["Crouton", "Cat", 1, "Do not leave bread unattended. Yes, the name is relevant."],
  ["Margaret Scratcher", "Cat", 11, "Senior stateswoman. Medication in pâté, never in jelly."],
  ["Bindi", "Blue-tongue Lizard", 6, "Salad at noon. Sun lamp on, opinions respected."],
  ["Sir Barksalot", "Dog", 2, "In training. Announces couriers, leaves and suspicious wheelie bins."],
  ["Lamington", "Rabbit", 4, "Free-roams the laundry. Will trade affection for coriander."],
  ["Pickles", "Dog", 9, "Gentle old soul. Carries one sock on every walk for confidence."],
  ["Bin Chicken", "Rescue Ibis", 2, "Recovering wing. Absolutely no takeaway containers, despite lobbying."],
  ["Wombat", "Cat", 5, "Not a wombat. Refuses to discuss how the misunderstanding began."],
  ["Tippy", "Dog", 6, "Needs her raincoat below 18°C, according to her."],
  ["Professor Fluff", "Rabbit", 3, "Quiet office companion currently researching banana distribution."],
  ["Chook Norris", "Chicken", 4, "Backyard boss. Bedtime at sunset; spinach tribute at dawn."],
  ["Pesto", "Dog", 1, "Puppy. Shoes go up high unless you want them taste-tested."],
  ["Gandalf", "Cat", 12, "You shall not pass the hallway without administering chin scratches."],
  ["Mochi", "Shiba Inu", 3, "Escape artist. Harness clip must click twice before the door opens."],
  ["Pixel", "Budgie", 2, "Likes jazz, dislikes vacuum cleaners and has strong screen-time opinions."],
  ["Meatball", "Dog", 8, "Slow walker, fast eater, world-class napper."],
  ["Lord Featherington", "Chicken", 2, "Very fancy, very punctual, deeply suspicious of garden gnomes."],
  ["Clover", "Rabbit", 5, "Hay always available. Stamps once for snacks, twice for management."],
  ["Bruce", "Dog", 4, "Big softie. Crosses the road to avoid tiny white dogs."]
]

puts "Creating a deeply unserious collection of pets..."

pets = pet_data.each_with_index.map do |(name, species, age, instructions), index|
  Pet.create!(
    user: users[index],
    name: name,
    species: species,
    age: age,
    care_instructions: instructions,
    profile_pic: "https://placehold.co/600x600?text=#{ERB::Util.url_encode(name)}"
  )
end

little_mike = Pet.create!(
  user: users.find { |user| user.name == "Baz" },
  name: "Little Mike",
  species: "Tiger",
  age: 3,
  care_instructions: "Named after Mike Tyson. Has never eaten anyone's children, " \
                     "but the legal team strongly recommends not testing that claim. " \
                     "Licensed wildlife carers only; admire from outside the habitat.",
  profile_pic: "https://placehold.co/600x600?text=Little+Mike"
)
pets << little_mike

extra_pet_data = [
  ["Tom", "Tax Evasion", "Ferret", 2,
   "Sleeps eighteen hours a day and spends the other six investigating unsecured handbags."],
  ["Sam", "Waffles", "Corgi", 4,
   "Built low to the ground for aerodynamic snack retrieval. One sensible walk, then sofa."],
  ["Priya", "Bluetooth", "Parrot", 6,
   "Connects automatically to every conversation and repeats the least convenient sentence."],
  ["Jerry", "Socks", "Cat", 5, "White paws, zero remorse. Check the laundry basket before starting a wash."],
  ["Emma", "Gnocchi", "Pug", 7, "Breathes like a tiny tractor. Keep walks short and avoid the midday heat."],
  ["Ziggy", "Tuna Turner", "Cat", 3,
   "Simply the best at opening cupboard doors. Dinner includes a short standing ovation."],
  ["Nina", "Gary", "Turtle", 14, "Fast by turtle standards. Slow by every other standard. Lettuce at noon."],
  ["Mei", "Boba", "Rabbit", 2, "Will reorganise the rug overnight. Unlimited hay and strictly supervised cables."],
  ["Hugo", "Frankie", "Dog", 5, "Scruffy optimist. Brings every visitor one leaf from his private collection."],
  ["Aisha", "Mabel", "Cat", 8, "Requests breakfast at 5:03am and files an appeal at 5:04am."],
  ["Finn", "Seagull Steve", "Rescue Seagull", 3,
   "Recovering wing. Guard your chips; rehabilitation has not changed his values."],
  ["Val", "Rocket", "Australian Kelpie", 4,
   "Needs a proper run and a job. Sorting socks counts as a job if supervised."],
  ["Nico", "Cannoli", "Cat", 4, "Sweet filling, crunchy exterior. Accepts pats until an undisclosed limit is reached."],
  ["Ruby", "Rupert", "Cocker Spaniel", 9,
   "Ears must be kept out of the water bowl. He will not assist with this process."],
  ["Dev", "Samosa", "Hamster", 1, "Nocturnal architect. Wheel squeaks at 2am because inspiration keeps unusual hours."]
]

extra_pet_data.each do |owner_name, name, species, age, instructions|
  pets << Pet.create!(
    user: users.find { |user| user.name == owner_name },
    name: name,
    species: species,
    age: age,
    care_instructions: instructions,
    profile_pic: "https://placehold.co/600x600?text=#{ERB::Util.url_encode(name)}"
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

listing_notes = [
  "Human required while I attend a wedding. Payment includes gratitude and excellent pet gossip.",
  "A quick lunchtime visit would prevent a strongly worded complaint from the resident.",
  "Looking for a calm walker who understands that sniffing one pole for six minutes is enrichment.",
  "Weekend away. Please provide dinner, company and one complimentary review of their outfit.",
  "I have an early shift and need backup from a neighbour with treats and good vibes.",
  "Two visits a day, plus watering the herb named after them. The herb is less demanding.",
  "Regular walk wanted. Route negotiable; stopping at every interesting smell is not.",
  "House-sit and enjoy the Wi-Fi. Pet may attempt to join video calls as regional manager."
]

puts "Creating listings in every corner of the map..."

listings = pets.each_with_index.map do |pet, index|
  start_offset = 1 + (index % 17)
  duration = 1 + (index % 4)
  listing_type = pet == little_mike ? "Sitting" : Listing::TYPES[index % Listing::TYPES.length]
  listing_note = if pet == little_mike
                   "Baz is away. Licensed tiger carers only—supervise enrichment from outside the habitat."
                 else
                   "#{listing_notes[index % listing_notes.length]} Please ask for #{pet.name} when you arrive."
                 end

  Listing.create!(
    pet: pet,
    listing_type: listing_type,
    start_date: Date.current + start_offset,
    end_date: Date.current + start_offset + duration,
    listing_note: listing_note
  )
end

# Extra posts make busy suburbs feel busy and exercise multi-listing owner screens.
pets.first(16).each_with_index do |pet, index|
  start_offset = 20 + (index % 10)
  listings << Listing.create!(
    pet: pet,
    listing_type: Listing::TYPES[(index + 1) % Listing::TYPES.length],
    start_date: Date.current + start_offset,
    end_date: Date.current + start_offset + 2,
    listing_note: "#{pet.name}'s encore booking: #{listing_notes[(index + 3) % listing_notes.length]}"
  )
end

# A few historical records keep the activity dashboard from looking freshly unwrapped.
pets.first(6).each_with_index do |pet, index|
  Listing.create!(
    pet: pet,
    listing_type: Listing::TYPES[index % 3],
    start_date: Date.current - 14 + index,
    end_date: Date.current - 12 + index,
    listing_note: "#{pet.name}'s previous booking was completed successfully. Nobody ate the couch (confirmed)."
  )
end

puts "Creating a mixture of pending, accepted and rejected offers..."

listings.each_with_index do |listing, index|
  candidates = users.reject { |user| user == listing.owner }
  primary = candidates[(index * 3) % candidates.length]
  status = (index % 7).zero? ? "accepted" : "offered"
  Offer.create!(listing: listing, user: primary, status: status)

  next unless (index % 3).zero?

  secondary = candidates[((index * 3) + 5) % candidates.length]
  Offer.create!(listing: listing, user: secondary, status: status == "accepted" ? "rejected" : "offered")
end

# Connections zig-zag across the city instead of forming one suspiciously tidy clique.
users.each_with_index do |user, index|
  Connection.create!(sender: user, receiver: users[(index + 1) % users.length])
  Connection.create!(sender: user, receiver: users[(index + 7) % users.length]) if index.even?
end

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

require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner = create_user("Alex", "alex@example.com", -33.8688, 151.2093)
    @neighbour = create_user("Sam", "sam@example.com", -33.8690, 151.2095)
    @listing = create_listing(@owner, "Milo", "Sitting", "Please stay overnight.")
    @nearby_listing = create_listing(@neighbour, "Luna", "Drop-in", "Top up Luna's food and water.")
    sign_in @owner
  end

  test "index focuses on available nearby listings" do
    get listings_url

    assert_response :success
    assert_select "h2", "Help nearby"
    assert_select "h3", "Luna"
    assert_select "h3", text: "Milo", count: 0
    assert_select "details.dashboard-disclosure", count: 0
  end

  test "index excludes listings the current user has already offered on" do
    Offer.create!(listing: @nearby_listing, user: @owner, status: "offered")

    get listings_url

    assert_response :success
    assert_select "h3", text: "Luna", count: 0
  end

  test "mine shows personal listings offers and attention items" do
    Offer.create!(listing: @listing, user: @neighbour, status: "offered")
    Offer.create!(listing: @nearby_listing, user: @owner, status: "offered")

    get mine_listings_url

    assert_response :success
    assert_select "h1", "My activity"
    assert_select "summary", text: /Needs your attention/
    assert_select "summary", text: /My listings/
    assert_select "summary", text: /My offers/
    assert_select "details[open]", text: /Needs your attention/
    assert_select "body", text: /Milo/
    assert_select "body", text: /Luna/
  end

  test "shows listing details" do
    get listing_url(@listing)

    assert_response :success
    assert_select "h1", "Milo"
    assert_select "body", text: /Sitting/
    assert_select "body", text: /Please stay overnight/
    assert_select "body", text: /Follow the owner's instructions/
    assert_select "body", text: /Alex/
  end

  test "returns not found for an unknown listing" do
    get listing_url(id: 0)

    assert_response :not_found
  end

  private

  def create_user(name, email, latitude, longitude)
    user = User.new(
      name: name,
      email: email,
      password: "password",
      location: "Sydney, NSW",
      latitude: latitude,
      longitude: longitude
    )

    # Coordinates are supplied explicitly, so the test does not need an
    # external Mapbox request during validation.
    user.save!(validate: false)
    user
  end

  def create_listing(owner, pet_name, listing_type, note)
    Listing.create!(
      pet: create_pet(owner, pet_name),
      listing_type: listing_type,
      start_date: Date.current + 1,
      end_date: Date.current + 3,
      listing_note: note
    )
  end

  def create_pet(owner, name)
    Pet.create!(
      user: owner,
      name: name,
      species: "Dog",
      age: 3,
      care_instructions: "Follow the owner's instructions."
    )
  end
end

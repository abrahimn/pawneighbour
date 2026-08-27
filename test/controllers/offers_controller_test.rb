require "test_helper"

class OffersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner = create_user("Alex", "alex-offers@example.com")
    @neighbour = create_user("Sam", "sam-offers@example.com")
    @pet = Pet.create!(
      user: @owner,
      name: "Milo",
      species: "Dog",
      age: 3,
      care_instructions: "Keep the water bowl full."
    )
    @listing = Listing.create!(
      owner: @owner,
      pets: [@pet],
      listing_type: "Sitting",
      start_date: Date.current + 1,
      end_date: Date.current + 2,
      listing_note: "Please stay overnight."
    )
    @offer = Offer.create!(listing: @listing, user: @neighbour, status: "offered")
    sign_in @owner
  end

  test "owner can review offers for a listing" do
    second_pet = Pet.create!(
      user: @owner,
      name: "Otis",
      species: "Dog",
      age: 4,
      care_instructions: "Keep Otis and Milo together."
    )
    @listing.pets << second_pet

    get listing_offers_url(@listing)

    assert_response :success
    assert_select "main.offers-page"
    assert_select "h1", "Help for Milo and Otis"
    assert_select "article.offer-card", count: 1
    assert_select "button", text: /Accept offer/
  end

  test "show route remains available for an offer" do
    get offer_url(@offer)

    assert_response :success
  end

  private

  def create_user(name, email)
    user = User.new(
      name: name,
      email: email,
      password: "password",
      location: "Sydney, NSW",
      latitude: -33.8688,
      longitude: 151.2093
    )
    user.save!(validate: false)
    user
  end
end

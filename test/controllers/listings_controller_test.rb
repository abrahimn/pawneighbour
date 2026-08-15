require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create!(name: "Alex", email: "alex@example.com", password: "password")
    @pet = Pet.create!(user: @owner, name: "Milo", species: "Dog", age: 3,
                       care_instructions: "One walk after breakfast.")
    @listing = Listing.create!(pet: @pet, listing_type: "Sitting",
                               start_date: Date.current + 1, end_date: Date.current + 3,
                               listing_note: "Please stay overnight.")
  end

  test "shows listing details" do
    get listing_url(@listing)

    assert_response :success
    assert_select "h1", "Milo"
    assert_select "body", text: /Sitting/
    assert_select "body", text: /Please stay overnight/
    assert_select "body", text: /One walk after breakfast/
    assert_select "body", text: /Alex/
  end

  test "returns not found for an unknown listing" do
    get listing_url(id: 0)

    assert_response :not_found
  end
end

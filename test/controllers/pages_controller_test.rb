require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home is a public landing page with clear signup paths" do
    get root_url

    assert_response :success
    assert_select "title", "Pawneighbour — Pet care, right around the corner"
    assert_select "main.landing"
    assert_select "h1", /Your pet’s village lives/
    assert_select "a#hero-join-cta[href='#{new_user_registration_path}']"
    assert_select "section#how-it-works"
    assert_select "section#faq details", minimum: 5
    assert_select "a#final-join-cta[href='#{new_user_registration_path}']"
    assert_select "meta[property='og:image'][content$='/og.png']", count: 1
    assert_select "script[type='application/ld+json']", count: 1
  end
end

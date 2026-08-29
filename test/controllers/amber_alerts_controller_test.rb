require "test_helper"

class AmberAlertsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get amber_alerts_index_url
    assert_response :success
  end

  test "should get new" do
    get amber_alerts_new_url
    assert_response :success
  end

  test "should get create" do
    get amber_alerts_create_url
    assert_response :success
  end

  test "should get show" do
    get amber_alerts_show_url
    assert_response :success
  end
end

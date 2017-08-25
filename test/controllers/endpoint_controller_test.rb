require 'test_helper'

class EndpointControllerTest < ActionDispatch::IntegrationTest
  test "should get slack" do
    get endpoint_slack_url
    assert_response :success
  end

end

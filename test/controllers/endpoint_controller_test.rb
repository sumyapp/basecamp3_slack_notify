require 'test_helper'

class EndpointControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get endpoint_index_url
    assert_response :success
  end

end

require 'test_helper'

class SetupControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get setup_index_url
    assert_response :success
  end

  test "should get callback" do
    get setup_callback_url
    assert_response :success
  end

end

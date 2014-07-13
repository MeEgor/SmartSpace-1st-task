require 'test_helper'

class PlaceControllerTest < ActionController::TestCase
  test "should get around" do
    get :around
    assert_response :success
  end

end

require 'test_helper'

class PageControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get test_a" do
    get :test_a
    assert_response :success
  end

  test "should get test_b" do
    get :test_b
    assert_response :success
  end

end

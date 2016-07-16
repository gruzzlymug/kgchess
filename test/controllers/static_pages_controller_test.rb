require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  # NOTE requires devise helpers to ensure proper authentication
  test 'should get index' do
    get :index, {}
    assert_response :success
  end
end

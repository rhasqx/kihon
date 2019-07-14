require 'test_helper'

class MiscControllerTest < ActionDispatch::IntegrationTest
  test "should get print" do
    get misc_print_url
    assert_response :success
  end

end

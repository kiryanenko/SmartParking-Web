require 'test_helper'

class ControlPanelControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get control_panel_main_url
    assert_response :success
  end

end

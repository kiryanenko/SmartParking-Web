require 'test_helper'

class ControlPanelControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  # Отображение главной страницы контрольной панели
  test "should get main" do
    get control_panel_main_url
    assert_response :success
  end
end

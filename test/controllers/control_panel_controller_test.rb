require 'test_helper'

class ControlPanelControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  # Отобразить главную страницу контрольной панели для авторизованного пользователя
  test "should get main" do
    sign_in @user
    get control_panel_main_url
    assert_response :success
  end

  # В экшене main перенаправить на страницу авторизации для не авторизованного пользователя
  test "in main should redirect to auth" do
    get control_panel_main_url
    assert_redirected_to new_user_session_path
  end

  # Отобразить страницу заказов для авторизованного пользователя
  test "should get orders" do
    sign_in @user
    get control_panel_orders_url
    assert_response :success
  end

  # В экшене main перенаправить на страницу авторизации для не авторизованного пользователя
  test "in orders should redirect to auth" do
    get control_panel_orders_url
    assert_redirected_to new_user_session_path
  end
end

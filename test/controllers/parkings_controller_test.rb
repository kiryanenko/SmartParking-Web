require 'test_helper'

class ParkingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking = parkings(:one)
    @user = users(:one)
  end

  test "should get index" do
    get parkings_url
    assert_response :success
  end

  test "should get new" do
    get new_parking_url
    assert_response :success
  end

  test "should create parking" do
    sign_in @user

    assert_difference('Parking.count') do
      post parkings_url, params: { parking: {
          area: @parking.area,
          cost: @parking.cost,
          description: @parking.description,
          end_time: @parking.end_time,
          start_time: @parking.start_time,
          title: @parking.title } }
    end

    assert_redirected_to parking_url(Parking.last)
  end

  test "should show parking" do
    get parking_url(@parking)
    assert_response :success
  end

  test "should get edit" do
    get edit_parking_url(@parking)
    assert_response :success
  end

  test "should update parking" do
    patch parking_url(@parking), params: { parking: { area: @parking.area, cost: @parking.cost, description: @parking.description, end_time: @parking.end_time, start_time: @parking.start_time, title: @parking.title, user_id_id: @parking.user_id_id } }
    assert_redirected_to parking_url(@parking)
  end

  test "should destroy parking" do
    assert_difference('Parking.count', -1) do
      delete parking_url(@parking)
    end

    assert_redirected_to parkings_url
  end

  # В контроллере parkings перенаправить на страницу авторизации для не авторизованного пользователя
  test "should redirect to auth" do
    assert_redirected_to_auth(
        [parkings_url, 'get'],
        [parkings_url, 'post'],
        [control_panel_orders_url, 'get'],
        [control_panel_orders_url, 'get'],
        )
  end
end

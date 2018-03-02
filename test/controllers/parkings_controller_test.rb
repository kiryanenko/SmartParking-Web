require 'test_helper'

class ParkingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking = parkings(:one)
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
    assert_difference('Parking.count') do
      post parkings_url, params: { parking: { area: @parking.area, cost: @parking.cost, description: @parking.description, end_time: @parking.end_time, start_time: @parking.start_time, title: @parking.title, user_id_id: @parking.user_id_id } }
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
end

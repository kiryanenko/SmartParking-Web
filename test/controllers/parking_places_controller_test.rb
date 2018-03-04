require 'test_helper'

class ParkingPlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking_place = parking_places(:one)
  end

  test "should get index" do
    get parking_places_url
    assert_response :success
  end

  test "should get new" do
    get new_parking_place_url
    assert_response :success
  end

  test "should create parking_place" do
    assert_difference('ParkingPlace.count') do
      post parking_places_url, params: { parking_place: { booked: @parking_place.booked, can_book: @parking_place.can_book, connected: @parking_place.connected, coords: @parking_place.coords, for_disabled: @parking_place.for_disabled, free: @parking_place.free, parking_id: @parking_place.parking_id, place_id: @parking_place.place_id, sensor_id: @parking_place.sensor_id, title: @parking_place.title } }
    end

    assert_redirected_to parking_place_url(ParkingPlace.last)
  end

  test "should show parking_place" do
    get parking_place_url(@parking_place)
    assert_response :success
  end

  test "should get edit" do
    get edit_parking_place_url(@parking_place)
    assert_response :success
  end

  test "should update parking_place" do
    patch parking_place_url(@parking_place), params: { parking_place: { booked: @parking_place.booked, can_book: @parking_place.can_book, connected: @parking_place.connected, coords: @parking_place.coords, for_disabled: @parking_place.for_disabled, free: @parking_place.free, parking_id: @parking_place.parking_id, place_id: @parking_place.place_id, sensor_id: @parking_place.sensor_id, title: @parking_place.title } }
    assert_redirected_to parking_place_url(@parking_place)
  end

  test "should destroy parking_place" do
    assert_difference('ParkingPlace.count', -1) do
      delete parking_place_url(@parking_place)
    end

    assert_redirected_to parking_places_url
  end
end

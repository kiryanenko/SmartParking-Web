require 'test_helper'

class ParkingTest < ActiveSupport::TestCase
  # Стоянка присутствует в заданном положении
  test "parking at location" do
    parking = parkings(:one)
    coord = {lat: parking.area.coordinates[0][0].first - 1, lng: parking.area.coordinates[0][0].second}
    radius = 1
    assert Parking.parkings_at_location(coord, radius).find(parking.id)
  end

  # Стоянка не присутствует в заданном положении
  test "parking not at location" do
    parking = parkings(:one)
    coord = {lat: parking.area.coordinates[0][0].first - 2, lng: parking.area.coordinates[0][0].second}
    radius = 1
    assert_raise ActiveRecord::RecordNotFound do
      Parking.parkings_at_location(coord, radius).find(parking.id)
    end
  end

  # Стоянка в заданном положении была отфильтрована
  test "parking at location filtered by params" do
    parking = parkings(:can_not_book)
    coord = {lat: parking.area.coordinates[0][0].first - 1, lng: parking.area.coordinates[0][0].second}
    radius = 2
    params = {can_book: true}
    assert_raise ActiveRecord::RecordNotFound do
      ParkingPlace.parking_places_at_location(coord, radius, params).find(parking.id)
    end
  end
end

require 'test_helper'

class ParkingPlaceTest < ActiveSupport::TestCase
  # Парковочное место присутствует в заданном положении
  test "parking place at location" do
    parking_place = parking_places(:one)
    coord = {lat: parking_place.coord.x - 1, lng: parking_place.coord.y + 1}
    radius = 2
    assert ParkingPlace.parking_places_at_location(coord, radius).find(parking_place.id)
  end

  # Парковочное место не присутствует в заданном положении
  test "parking place not at location" do
    parking_place = parking_places(:one)
    coord = {lat: parking_place.coord.x - 2, lng: parking_place.coord.y + 2}
    radius = 1
    assert_raise ActiveRecord::RecordNotFound do
      ParkingPlace.parking_places_at_location(coord, radius).find(parking_place.id)
    end
  end

  # Парковочное место в заданном положении было отфильтровано
  test "parking place at location filtered by params" do
    parking_place = parking_places(:can_not_book)
    coord = {lat: parking_place.coord.x - 1, lng: parking_place.coord.y + 1}
    radius = 2
    params = {can_book: true}
    assert_raise ActiveRecord::RecordNotFound do
      ParkingPlace.parking_places_at_location(coord, radius, params).find(parking_place.id)
    end
  end
end

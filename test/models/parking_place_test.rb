require 'test_helper'

class ParkingPlaceTest < ActiveSupport::TestCase
  # Парковочное место присутствует в заданном положении
  test "parking place at location" do
    parking_place = parking_places(:one)
    coord = {lat: parking_place.coord.x - 1, lng: parking_place.coord.y + 1}
    radius = 2
    assert ParkingPlace.parking_places_at_location(coord, radius).includes(id: parking_place.id)
  end

  # Парковочное место не присутствует в заданном положении
  test "parking place not at location" do
    parking_place = parking_places(:one)
    coord = {lat: parking_place.coord.x - 2, lng: parking_place.coord.y + 2}
    radius = 1
    assert_not ParkingPlace.parking_places_at_location(coord, radius).includes(id: parking_place.id)
  end
end

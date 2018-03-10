class MapClient
  attr_reader :id
  attr_accessor :coord, :radius

  def initialize(id, coord, radius)
    @id = id
    @coord = coord
    @radius = radius
  end

  def send_parkings
    params = {}
    places = ParkingPlace.parking_places_at_location @coord, @radius, params
    parkings = Parking.parking_places_at_location @coord, @radius, params
  end
end
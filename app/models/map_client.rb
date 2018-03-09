class MapClient
  attr_reader :id
  attr_accessor :coord, :radius

  def initialize(id, coord, radius)
    @id = id
    @coord = coord
    @radius = radius
  end

  def send_changed_parkings
    params = {changed: true}
    ParkingPlace.parking_places_in_area @coord, @radius, params
  end
end
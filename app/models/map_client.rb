class MapClient
  attr_reader :id
  attr_accessor :coord, :radius

  def initialize(id, coord, radius)
    @id = id
    @coord = coord
    @radius = radius
  end

  def send_parkings
    params = {}       # FIXME: В дальнешем тут будут параметры поиска
    places = ParkingPlace.parking_places_at_location @coord, @radius, params
    parkings = Parking.parkings_at_location @coord, @radius, params

    response = {
        parkings: parkings,
        parking_places: places
    }
    MapChannel.broadcast_to @id, response
  end
end
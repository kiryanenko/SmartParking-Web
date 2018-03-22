class MapClient
  attr_reader :id
  attr_accessor :coord, :radius

  def initialize(id, coord, radius)
    @id = id
    @coord = coord
    @radius = radius
    @last_send = Time.now
  end

  def send_parkings
    params = {}       # FIXME: В дальнешем тут будут параметры поиска
    places = ParkingPlace.parking_places_at_location @coord, @radius, params
    parkings = Parking.parkings_at_location @coord, @radius, params

    response = {
        parkings: parkings.map { |parking| parking.response },
        parking_places: places.map { |place| place.response }
    }
    ActionCable.server.broadcast @id, response

    @last_send = Time.now
  end

  def set(params)
    @coord = params[:coord]
    @radius = params[:radius]

    send_parkings if Time.now - @last_send > Rails.configuration.websocket_sending_period_on_update
  end
end
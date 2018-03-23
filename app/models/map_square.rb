class MapSquare
  attr_reader :coord, :radius

  def initialize(params)
    r_min = Rails.configuration.min_map_square_side / 2

    @radius = r_min
    if params[:radius] > r_min
      scale = Math.log2(params[:radius] / r_min).ceil
      @radius = r_min * (2 ** scale)
    end

    n_lat = (params[:coord][:lat] / @radius).floor
    n_lng = (params[:coord][:lng] / @radius).floor
    @coord = {
        lat: params[:coord][:lat].near(@radius * n_lat, @radius * (n_lat + 1)),
        lng: params[:coord][:lng].near(@radius * n_lng, @radius * (n_lng + 1))
    }
  end

  def parkings
    params = {}       # FIXME: В дальнешем тут будут параметры поиска
    places = ParkingPlace.parking_places_at_location @coord, @radius, params
    parkings = Parking.parkings_at_location @coord, @radius, params

    {
        parkings: parkings.map { |parking| parking.response },
        parking_places: places.map { |place| place.response }
    }
  end

  def broadcast
    ActionCable.server.broadcast stream, parkings
  end

  def stream
    "square_R:#{@radius}_LAT:#{@coord[:lat]}_LNG:#{@coord[:lng]}"
  end
end

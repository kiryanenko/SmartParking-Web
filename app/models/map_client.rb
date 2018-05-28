class MapClient
  attr_reader :id, :square

  def initialize(id, params)
    @id = id
    @square = MapSquare.new params
    @last_send = Time.now
  end

  def send_parkings
    parkings = @square.parkings_cache
    ActionCable.server.broadcast stream, parkings
    @last_send = Time.now
  end

  def set(params)
    @square = MapSquare.new params
    send_parkings if Time.now - @last_send > Rails.configuration.min_map_sending_period
  end

  def stream
    "client_#{id}"
  end
end

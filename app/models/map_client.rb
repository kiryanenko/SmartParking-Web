require './app/utils/numeric'

class MapClient
  attr_reader :id, :square

  def initialize(id, params)
    @id = id
    @square = MapSquare.new params
    @last_send = Time.now
  end

  def send_parkings
    ActionCable.server.broadcast stream, @square.parkings
    @last_send = Time.now
  end

  def set(params)
    @square = MapSquare.new params
    send_parkings if Time.now - @last_send > Rails.configuration.websocket_sending_period_on_update
  end

  def stream
    "client_#{id}"
  end
end
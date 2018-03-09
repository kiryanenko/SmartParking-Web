require 'singleton'

class MapService
  include Singleton

  def initialize
    @map_clients = Hash.new
  end

  def add_client(client)
    @map_clients[client.id] = client
  end

  def remove_client(id)
    @map_clients.remove id
  end

  private
  def run
    Thread.new do
      loop do
        @map_clients.each_value do |client|
          client.send_changed_parkings
        end
        ParkingPlace.unset_changed
      end
    end
  end
end
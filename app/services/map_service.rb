require 'singleton'

class MapService
  include Singleton

  def initialize
    @map_clients = Hash.new
    run
  end

  def add_client(client)
    @map_clients[client.id] = client
  end

  def remove_client(id)
    @map_clients.delete id
  end

  def set_client(id, params)
    @map_clients[id].set params
  end

  def get_client(id)
    @map_clients[id]
  end

  private
  def run
    Thread.new do
      loop do
        begin
          @map_clients.each_value do |client|
            client.send_parkings
          end
          ParkingPlace.unset_changed
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end
        sleep Rails.configuration.websocket_sending_period
      end
    end
  end
end

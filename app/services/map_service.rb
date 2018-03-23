require 'singleton'

class MapService
  include Singleton

  def initialize
    @map_clients = Hash.new
    @squares = Hash.new
    @squares_m = Mutex.new
    run
  end

  def add_client(client)
    @map_clients[client.id] = client
    add_square client.square
  end

  def remove_client(id)
    remove_square @map_clients[id].square
    @map_clients.delete id
  end

  def update_client(client, params)
    remove_square client.square
    client.set params
    add_square client.square
  end

  def get_client(id)
    @map_clients[id]
  end

  def add_square(square)
    @squares_m.synchronize do
      if @squares.has_key? square.stream
        sq = @squares[square.stream]
        sq[:count] = sq[:count] + 1
      else
        @squares[square.stream] = {square: square, count: 1}
      end
    end
  end

  def remove_square(square)
    @squares_m.synchronize do
      count = @squares[square.stream][:count] - 1
      @squares[square.stream][:count] = count

      if count <= 0
        @squares.delete square.stream
      end
    end
  end

  private
  def run
    Thread.new do
      loop do
        before = Time.now

        begin
          values = []
          @squares_m.synchronize { values = @squares.values.dup }
          values.each do |value|
            value[:square].broadcast
          end
          ParkingPlace.unset_changed
        rescue Exception => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace
        end

        sleep_time = Rails.configuration.map_sending_period - (Time.now - before)
        sleep sleep_time if sleep_time > 0
      end
    end
  end
end

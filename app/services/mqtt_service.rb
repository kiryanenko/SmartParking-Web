class MQTTService
  include Singleton

  def initialize
    begin
      connect
    rescue Exception => e
      Rails.logger.error 'ERROR! Can not connect to MQTT: ' + e.message
      Rails.logger.error e.backtrace
    end
  end

  def connect
    @client = MQTT::Client.connect(ENV["MQTT_URI"] || ENV["CLOUDMQTT_URL"] || 'mqtt://0.0.0.0')
    @client.subscribe 'init'
    @client.subscribe 'status'
    run
  end

  private
  def run
    Thread.new do
      @client.get do |topic,message|
        begin
          data = JSON.parse(message).transform_keys! {|k| k.to_sym }
          user = User.authenticate! data[:login], data[:password]

          case topic
            when 'init'
              sensor = Sensor.find_for_user data[:sensor], user
              sensor.update(
                  sampling_period: data[:sampling_period],
                  sending_period: data[:sending_period],
                  day_cost: data[:day_cost],
                  night_cost: data[:night_cost],
                  day_start_time: data[:day_start_time],
                  night_start_time: data[:night_start_time],
                  )
            when 'status'
              place = ParkingPlace.find_by_place_id_and_user data[:place_id], data[:sensor], user
              ParkingState.set_state place, data[:free]
            else
              Rails.logger.error 'ERROR! UNDEFINED TOPIC'
          end
        rescue User::AuthenticationFail => e
          Rails.logger.warn e.message
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.warn e.message
          Rails.logger.warn e.backtrace
        rescue Exception => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace
        end
      end
    end
  end
end

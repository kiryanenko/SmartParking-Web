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
    @mqtt = MQTT::Client.connect(ENV["MQTT_URI"] || ENV["CLOUDMQTT_URL"] || 'mqtt://0.0.0.0')

    @mqtt.subscribe 'init'
    @mqtt.subscribe 'status'
    @mqtt.subscribe 'payment'

    run
  end

  def set_settings(sensor)
    begin
      @mqtt.publish("sensor_#{sensor.id}-settings", JSON.generate({
                                                             sampling_period: sensor.sampling_period,
                                                             sending_period: sensor.sending_period,
                                                             day_cost: sensor.day_cost,
                                                             night_cost: sensor.night_cost,
                                                             day_start_time: sensor.day_start_time,
                                                             night_start_time: sensor.night_start_time
                                                         }))
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
    end
  end

  def book(parking_place, booking_time)
    begin
      @mqtt.publish("sensor_#{parking_place.sensor.id}-book", JSON.generate({
                                                                                place_id: parking_place.place_id,
                                                                                booking_time: booking_time,
                                                                            }))
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
    end
  end

  private
  def run
    Thread.new do
      @mqtt.get do |topic,message|
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
                night_start_time: data[:night_start_time]
            )

          when 'status'
            place = ParkingPlace.find_by_place_id_and_user data[:place_id], data[:sensor], user
            ParkingState.set_state place, data[:free]

          when 'payment'
            place = ParkingPlace.find_by_place_id_and_user data[:place_id], data[:sensor], user
            order = Order.payment(nil, place, data[:booked_time], data[:payment], data[:cost])
            order.save!

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

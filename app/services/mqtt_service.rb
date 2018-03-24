class MQTTService
  include Singleton

  def initialize
    begin
      connect
    rescue Exception => e
      Rails.logger.error 'ERROR! Can not connect to MQTT: ' + e.message
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  def connect
    @client = MQTT::Client.connect(ENV["MQTT_URI"] || ENV["CLOUDMQTT_URL"] || 'mqtt://0.0.0.0')
    @client.subscribe 'status'
    run
  end

  private
  def run
    Thread.new do
      @client.get do |topic,message|
        begin
          case topic
            when 'status'
              # TODO
            else
              Rails.logger.error 'ERROR! UNDEFINED TOPIC'
          end
        rescue Exception => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.inspect
        end
      end
    end
  end
end

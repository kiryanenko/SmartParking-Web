class MQTTService
  include Singleton

  def initialize
    begin
      connect
    rescue Exception => e
      puts 'ERROR! Can not connect to MQTT'
      puts e.message
      puts e.backtrace.join("\n")
    end
  end

  def connect
    @client = MQTT::Client.connect(ENV.fetch("MQTT_URI") { 'mqtt://0.0.0.0' })

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
              puts 'ERROR! UNDEFINED TOPIC'
          end
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end
      end
    end
  end
end

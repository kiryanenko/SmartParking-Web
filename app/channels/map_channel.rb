require './app/utils/hash'

class MapChannel < ApplicationCable::Channel
  def subscribed
    client_id = connection.id
    client = MapClient.new client_id, params

    stream_from client.stream
    stream_from client.square.stream
    client.send_parkings

    MapService.instance.add_client client
  end

  def unsubscribed
    MapService.instance.remove_client connection.id
  end

  def receive(data)
    data.recursive_transform_keys! {|k| k.to_sym }
    client = MapService.instance.get_client connection.id

    stop_all_streams
    stream_from client.stream

    MapService.instance.update_client client, data
    stream_from client.square.stream
  end
end

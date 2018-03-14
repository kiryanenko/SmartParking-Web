class MapChannel < ApplicationCable::Channel
  def subscribed
    client_id = connection.id
    client = MapClient.new client_id, params[:coord], params[:radius]
    stream_from client_id

    client.send_parkings
    MapService.instance.add_client client
  end

  def unsubscribed
    MapService.instance.remove_client connection.id
  end

  def receive(data)
    data.transform_keys! {|k| k.to_sym }
    data[:coord].transform_keys! {|k| k.to_sym }
    MapService.instance.set_client connection.id, data
  end
end

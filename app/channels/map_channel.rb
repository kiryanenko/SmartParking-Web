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
end

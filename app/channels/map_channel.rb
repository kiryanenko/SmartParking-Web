class MapChannel < ApplicationCable::Channel
  def subscribed
    client_id = connection
    stream_from client_id

    client = MapClient.new client_id, params[:coord], params[:diag]
    client.send_parkings
    MapService.instance.add_client client
  end

  def unsubscribed
    MapService.instance.remove_client connection
  end
end

class MapChannel < ApplicationCable::Channel
  def subscribed
    client_id = connection_identifier
    stream_from client_id

    client = MapClient.new client_id, params[:coord], params[:diag]
    client.send_parkings
    MapService.add_client client
  end

  def unsubscribed
    MapService.remove_client connection_identifier
  end
end

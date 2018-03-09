class MapChannel < ApplicationCable::Channel
  def subscribed
    client_id = connection_identifier
    client = MapClient.new client_id, params[:coord], params[:diag]
    MapService.add_client client

    stream_from client_id
  end

  def unsubscribed
    MapService.remove_client connection_identifier
  end
end

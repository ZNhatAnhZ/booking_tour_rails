class AuthorizationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "authorization_channel_#{params[:room]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def receive data
    ActionCable.server.broadcast("authorization_channel_#{params[:room]}", data)
  end
end

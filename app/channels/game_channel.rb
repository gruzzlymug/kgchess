# Web socket used to exchange gameplay information
class GameChannel < ApplicationCable::Channel
  def subscribed
    # TODO: pass id (params[:id]) to scope messages
    stream_from 'game:game_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

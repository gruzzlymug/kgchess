# Controller for the Piece model, used to return piece data as JSON.
class PiecesController < ApplicationController
  before_action :authenticate_player!

  def index
    game = Game.find(params[:game_id])
    active_pieces = game.pieces.active
    render json: active_pieces
  end
end

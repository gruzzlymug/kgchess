# Controller for the Piece model, used to return piece data as JSON.
class PiecesController < ApplicationController
  before_action :authenticate_player!

  def index
    game = Game.find(params[:game_id])
    render json: game.pieces
  end
end

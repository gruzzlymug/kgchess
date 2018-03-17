# Controller for the Piece model, used to return piece data as JSON.
class PiecesController < ApplicationController
  before_action :authenticate_player!

  def index
    game = Game.find(params[:game_id])
    white_id = game.white_player_id
    black_id = game.black_player_id
    active_pieces = game.pieces.active
    render json: active_pieces.map { |p| as_json_with_color(p, white_id, black_id) }
  end

  private

  # color is replaced here instead of in the piece model to avoid N+1 queries
  # on the game model
  def as_json_with_color(piece, white_id, black_id)
    piece_json = piece.as_json
    player_id = piece_json.delete("player_id")
    color = player_id == white_id ? :white : :black
    piece_json["player"] = color
    piece_json
  end
end

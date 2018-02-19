# Controller for the Game model. Standard Rails stuff.
class GamesController < ApplicationController
  before_action :authenticate_player!

  def index
    if player_signed_in?
      @white_games = current_player.white_games
      @black_games = current_player.black_games
      @open_games = Game.available_to_join(current_player.id)
    end
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    game.white_player_id = current_player.id
    game.save

    redirect_to games_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    # TODO: this is a temporary construction
    # longer term this should be an agnostic method called by a client that
    # can layer on semantics and act accordingly on success (or failure).
    # TODO: use strict params
    cmd = params[:cmd]
    case cmd
    when 'join'
      player_id = current_player.id
      if game.join(player_id)
        game.create_white_pieces
        game.create_black_pieces
      end
    when 'select'
      selected = game.select_piece(current_player.id, params[:pieceId])
    when 'move'
      moved = game.move_selected_piece(current_player.id, params[:row], params[:col])
    else
      puts "Unknown command, cannot update game"
    end

    respond_to do |format|
      format.html { redirect_to game_path }
      format.json { render json: game }
    end
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end

# Controller for the Game model. Standard Rails stuff.
class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :set_player_cookie

  def set_player_cookie
    cookies[:player_id] = current_player.id || 'player'
  end

  def index
    @white_games = current_player.white_games
    @black_games = current_player.black_games
    @open_games = Game.available_to_join(current_player.id)
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params.merge(white_player_id: current_player.id))
    game.save

    redirect_to games_path
  end

  def show
    @game = Game.find(params[:id])

    game_json = @game.as_json
    active_pieces_json = @game.pieces.active.to_a.map!(&:as_json)
    game_json[:active_pieces] = active_pieces_json
    respond_to do |format|
      format.html
      format.json { render json: game_json }
    end
  end

  def update
    game = Game.find(params[:id])
    # TODO: this is a temporary construction
    # longer term this should be an agnostic method called by a client that
    # can layer on semantics and act accordingly on success (or failure).
    # TODO: use strict params
    cmd = params[:cmd]
    puts "COMMAND: #{cmd}"
    case cmd
    when 'join'
      joined = game.join(current_player.id)
      puts 'FAILED TO JOIN' unless joined
    when 'select'
      selected = game.select_piece(current_player.id, params[:pieceId])
      puts 'FAILED TO SELECT PIECE' unless selected
    when 'move'
      handle_move(game, params)
    else
      puts 'Unknown command, cannot update game'
    end

    respond_to do |format|
      format.html { redirect_to game_path }
      format.json { render json: game }
    end
  end

  private

  def handle_move(game, params)
    pos_x = params[:col].to_i
    pos_y = params[:row].to_i
    moved = game.move_selected_piece(current_player.id, pos_x, pos_y)
    if moved
      # TODO: scope messages to interested players/viewers
      GameChannel.broadcast_to('game_channel', pos_x: pos_x, pos_y: pos_y)
    else
      puts 'FAILED TO MOVE PIECE'
    end
  end

  def game_params
    params.require(:game).permit(:name)
  end
end

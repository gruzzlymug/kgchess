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
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end

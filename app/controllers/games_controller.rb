class GamesController < ApplicationController
  before_action :authenticate_player!

  def index
    if player_signed_in?
      @white_games = current_player.white_games
      @black_games = current_player.black_games
      @open_games = open_games
    end
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    game.white_player_id = current_player.id
    game.save

    redirect_to static_pages_index_path
  end

  private

  def open_games
    t = Game.arel_table
    games = Game.where(t[:white_player_id].eq(nil).or(t[:black_player_id].eq(nil)))
    games = games.reject { |g| g.white_player_id == current_player.id }
    games.reject { |g| g.black_player_id == current_player.id }
  end

  def game_params
    params.require(:game).permit(:name)
  end
end

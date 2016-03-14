class GamesController < ApplicationController
  before_action :authenticate_player!

  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    game.white_player_id = current_player.id
    game.save
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end

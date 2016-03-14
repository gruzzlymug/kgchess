class StaticPagesController < ApplicationController
  def index
    if player_signed_in?
      @white_games = current_player.white_games
      @black_games = current_player.black_games
    end
  end

  def about
  end
end

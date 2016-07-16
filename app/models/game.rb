# Top-level model for a chess game
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'

  has_many :pieces

  def self.available_to_join(player_id)
    t = Game.arel_table
    white_id = t[:white_player_id]
    black_id = t[:black_player_id]
    games = Game.where(white_id.eq(nil).or(black_id.eq(nil)))
    games = games.reject { |g| g.white_player_id == player_id }
    games.reject { |g| g.black_player_id == player_id }
  end

  def white_pieces
    return [] unless white_player
    pieces.where(player_id: white_player.id)
  end

  def black_pieces
    return [] unless black_player
    pieces.where(player_id: black_player.id)
  end
end

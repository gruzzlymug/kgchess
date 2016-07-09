class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'

  has_many :pieces

  def white_pieces
    return [] unless white_player
    pieces.where(player_id: white_player.id)
  end

  def black_pieces
    return [] unless black_player
    pieces.where(player_id: black_player.id)
  end
end

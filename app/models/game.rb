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

  # TODO: try with scopes
  def white_pieces
    return [] unless white_player
    pieces.where(player_id: white_player.id)
  end

  def black_pieces
    return [] unless black_player
    pieces.where(player_id: black_player.id)
  end

  def joinable?(player_id)
    not_playing = player_id != white_player_id && player_id != black_player_id
    has_open_slot = !white_player_id || !black_player_id
    not_playing && has_open_slot
  end

  def join(player_id)
    # NOTE assumes always joining as black for now
    update_attributes(black_player_id: player_id) unless black_player_id
  end

  def create_white_pieces
    (0..7).each do |pawn_x|
      Pawn.create(game_id: id, player_id: white_player_id, pos_x: pawn_x, pos_y: 1)
    end
    (0..1).each do |which|
      s = which * 7
      f = which == 0 ? 1 : -1
      Rook.create(game_id: id, player_id: white_player_id, pos_x: s, pos_y: 0)
      Knight.create(game_id: id, player_id: white_player_id, pos_x: s+f, pos_y: 0)
      Bishop.create(game_id: id, player_id: white_player_id, pos_x: s+f*2, pos_y: 0)
    end
  end

  def create_black_pieces
    (0..7).each do |pawn_x|
      Pawn.create(game_id: id, player_id: black_player_id, pos_x: pawn_x, pos_y: 6)
    end
    (0..1).each do |which|
      s = which * 7
      f = which == 0 ? 1 : -1
      Rook.create(game_id: id, player_id: black_player_id, pos_x: s, pos_y: 7)
      Knight.create(game_id: id, player_id: black_player_id, pos_x: s+f, pos_y: 7)
      Bishop.create(game_id: id, player_id: black_player_id, pos_x: s+f*2, pos_y: 7)
    end
  end
end

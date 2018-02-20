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
    create_pieces(white_player_id, 6, 7)
  end

  def create_black_pieces
    create_pieces(black_player_id, 1, 0)
  end

  def create_pieces(player_id, pawn_row, other_row)
    (0..7).each do |pawn_x|
      Pawn.create(game_id: id, player_id: player_id, pos_x: pawn_x, pos_y: pawn_row)
    end
    (0..1).each do |which|
      s = which * 7
      f = which.zero? ? 1 : -1
      Rook.create(game_id: id, player_id: player_id, pos_x: s, pos_y: other_row)
      Knight.create(game_id: id, player_id: player_id, pos_x: s + f, pos_y: other_row)
      Bishop.create(game_id: id, player_id: player_id, pos_x: s + f * 2, pos_y: other_row)
    end
    Queen.create(game_id: id, player_id: player_id, pos_x: 3, pos_y: other_row)
    King.create(game_id: id, player_id: player_id, pos_x: 4, pos_y: other_row)
  end

  def select_piece(player_id, piece_id)
    selection = pieces.where(player_id: player_id, id: piece_id)
    return false if selection.nil?

    pieces.update(status: 'ok')
    selection.update(status: 'selected')
    true
  end

  def move_selected_piece(player_id, dest_x, dest_y)
    # TODO: validate - destination must be on the board
    mover = pieces.where(player_id: player_id, status: 'selected').first
    return false if mover.nil?
    return false if mover.obstructed?(dest_x, dest_y)

    mover.update(pos_x: dest_x, pos_y: dest_y)
    true
  end
end

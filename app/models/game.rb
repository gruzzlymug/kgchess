# Top-level model for a chess game
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'

  has_many :pieces, dependent: :delete_all
  belongs_to :selected_piece, class_name: 'Piece'

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
    return unless black_player_id.nil?

    update(black_player_id: player_id)
    create_white_pieces
    create_black_pieces
  end

  def add_white_piece(type, pos_x, pos_y)
    add_piece(type, white_player_id, pos_x, pos_y)
  end

  def add_black_piece(type, pos_x, pos_y)
    add_piece(type, black_player_id, pos_x, pos_y)
  end

  def player_turn
    return nil unless white_player_id && black_player_id
    (turn % 2).zero? ? white_player_id : black_player_id
  end

  def select_piece(player_id, piece_id)
    return false unless player_turn == player_id

    selection = pieces.where(player_id: player_id, id: piece_id, status: 'true')
    return false if selection.nil?

    update(selected_piece_id: piece_id)
    true
  end

  def move_selected_piece(player_id, dest_x, dest_y)
    return false unless player_turn == player_id

    return false if selected_piece.nil?
    return false unless selected_piece.valid_move?(dest_x, dest_y)

    opponent = piece_at(dest_x, dest_y)
    capture(opponent) unless opponent.nil?

    selected_piece.move_to(dest_x, dest_y)
    true
  end

  def piece_at(pos_x, pos_y)
    pieces.where(pos_x: pos_x, pos_y: pos_y).first
  end

  private

  def create_white_pieces
    create_pieces(white_player_id, 6, 7)
  end

  def create_black_pieces
    create_pieces(black_player_id, 1, 0)
  end

  def create_pieces(player_id, pawn_row, other_row)
    (0..7).each do |pawn_x|
      add_piece('Pawn', player_id, pawn_x, pawn_row)
    end
    (0..1).each do |which|
      s = which * 7
      f = which.zero? ? 1 : -1
      add_piece('Rook', player_id, s, other_row)
      add_piece('Knight', player_id, s + f, other_row)
      add_piece('Bishop', player_id, s + f * 2, other_row)
    end
    add_piece('Queen', player_id, 3, other_row)
    add_piece('King', player_id, 4, other_row)
  end

  def add_piece(type, player_id, pos_x, pos_y)
    props = {
      type: type,
      game_id: id,
      player_id: player_id,
      pos_x: pos_x,
      pos_y: pos_y
    }
    Piece.create(props)
  end

  def capture(piece)
    piece.update(status: 'false', pos_x: nil, pos_y: nil)
  end
end

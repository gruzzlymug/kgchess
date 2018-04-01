# Base class for STI chess piece models
# Pieces have a 'status' field (a string). For now it will be treated as a
# boolean value: 'true' if the piece is on the board, 'false' otherwise.
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  scope :active, -> { where(status: 'true') }

  def initialize(params)
    super(params.merge(status: 'true'))
  end

  def valid_move?(dest_x, dest_y)
    return false if dest_x.negative? || dest_y.negative?
    return false if dest_x > 7 || dest_y > 7

    return false if dest_x == pos_x && dest_y == pos_y
    true
  end

  def obstructed?(dest_x, dest_y)
    blocker = game.piece_at(dest_x, dest_y)
    return true unless blocker.nil? || blocker.opponent?(player_id)

    movement = move_type(dest_x, dest_y)
    return false if movement == :unchecked
    return false if movement == :no_move

    path_obstructed?(movement, dest_x, dest_y)
  end

  def move_to(dest_x, dest_y)
    move_count = moves + 1
    update(pos_x: dest_x, pos_y: dest_y, moves: move_count)
    game.turn += 1
    game.save!
  end

  def opponent?(other_player_id)
    player_id != other_player_id
  end

  def as_json(*)
    json = super
    json = json.except('game_id', 'moves', 'status', 'created_at', 'updated_at')
    json[:type] = type
    json
  end

  private

  def move_type(dest_x, dest_y)
    udx = (dest_x - pos_x).abs
    udy = (dest_y - pos_y).abs

    return :no_move if udx.zero? && udy.zero?
    return :vert if udx.zero?
    return :horiz if udy.zero?
    return :diag if udx == udy
    :unchecked
  end

  def path_obstructed?(movement, dest_x, dest_y)
    case movement
    when :vert
      return vertically_obstructed?(dest_y)
    when :horiz
      return horizontally_obstructed?(dest_x)
    when :diag
      return diagonally_obstructed?(dest_x, dest_y)
    end

    raise "Unexpected move type: #{movement}"
  end

  def vertically_obstructed?(dest_y)
    min_y = [pos_y, dest_y].min
    max_y = [pos_y, dest_y].max
    # NOTE: file as in "rank and file"
    pieces_in_file = game.pieces.where(pos_x: pos_x)
    obstructors = pieces_in_file.where('pos_y > ? AND pos_y < ?', min_y, max_y)
    obstructors.any?
  end

  def horizontally_obstructed?(dest_x)
    min_x = [pos_x, dest_x].min
    max_x = [pos_x, dest_x].max
    pieces_in_rank = game.pieces.where(pos_y: pos_y)
    obstructors = pieces_in_rank.where('pos_x > ? AND pos_x < ?', min_x, max_x)
    obstructors.any?
  end

  def diagonally_obstructed?(dest_x, dest_y)
    ndx = normalized_delta(pos_x, dest_x)
    ndy = normalized_delta(pos_y, dest_y)
    cx = pos_x + ndx
    cy = pos_y + ndy
    loop do
      return false if cx == dest_x
      return true if game.piece_at(cx, cy).present?
      cx += ndx
      cy += ndy
    end
  end

  def normalized_delta(from, to)
    delta = to - from
    delta / delta.abs
  end
end

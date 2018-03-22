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

    dx = dest_x - pos_x
    dy = dest_y - pos_y
    udx = dx.abs
    udy = dy.abs
    movement = move_type(udx, udy)
    case movement
    when 'unchecked'
      return false
    when 'vert'
      return obs_vert?(dest_y)
    when 'horiz'
      return obs_horiz?(dest_x)
    when 'diag'
      ndx = dx / udx
      ndy = dy / udy
      return obs_diag?(dest_x, ndx, ndy)
    when 'no_move'
      return false
    else
      puts "Unexpected move type: #{movement}"
    end

    false
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

  def move_type(udx, udy)
    return 'no_move' if udx.zero? && udy.zero?
    return 'vert' if udx.zero?
    return 'horiz' if udy.zero?
    return 'diag' if udx == udy
    'unchecked'
  end

  def obs_vert?(dest_y)
    min_y = [pos_y, dest_y].min
    max_y = [pos_y, dest_y].max
    obstructors = game.pieces.where(pos_x: pos_x).where('pos_y > ? AND pos_y < ?', min_y, max_y)
    obstructors.any?
  end

  def obs_horiz?(dest_x)
    min_x = [pos_x, dest_x].min
    max_x = [pos_x, dest_x].max
    obstructors = game.pieces.where(pos_y: pos_y).where('pos_x > ? AND pos_x < ?', min_x, max_x)
    obstructors.any?
  end

  def obs_diag?(dest_x, ndx, ndy)
    cx = pos_x + ndx
    cy = pos_y + ndy
    loop do
      break if cx == dest_x
      obstructors = game.pieces.where(pos_x: cx).where(pos_y: cy)
      return true if obstructors.any?
      cx += ndx
      cy += ndy
    end
    false
  end
end

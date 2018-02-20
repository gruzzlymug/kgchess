# Base class for STI chess piece models
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def obstructed?(dest_x, dest_y)
    movement = move_type(dest_x, dest_y)

    case movement
    when 'unchecked'
      return false
    when 'vert'
      return true
    when 'horiz'
      return true
    when 'diag'
      return true
    end

    false
  end

  private

  def move_type(dest_x, dest_y)
    dx = dest_x - pos_y
    dy = dest_y - pos_y
    return 'no_move' if (dx + dy).zero?

    move_type = 'unchecked'
    move_type = 'vert' if dx.zero?
    move_type = 'horiz' if dy.zero?
    move_type = 'diag' if dx.abs == dy.abs
    move_type
  end
end

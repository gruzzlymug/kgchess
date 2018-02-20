# Base class for STI chess piece models
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def obstructed?(dest_x, dest_y)
    #puts "p (#{pos_x},#{pos_y}), d (#{dest_x},#{dest_y})"

    movement = move_type(dest_x, dest_y)
    #puts "Movement: #{movement}"
    case movement
    when 'unchecked'
      return false
    when 'vert'
      min_y = [pos_y, dest_y].min
      max_y = [pos_y, dest_y].max
      obstructors = game.pieces.where(pos_x: pos_x).where("pos_y > ? AND pos_y < ?", min_y, max_y)
      #puts "Found #{obstructors.size} things in the way"
      return obstructors.any?
    when 'horiz'
      min_x = [pos_x, dest_x].min
      max_x = [pos_x, dest_x].max
      obstructors = game.pieces.where(pos_y: pos_y).where("pos_x > ? AND pos_x < ?", min_x, max_x)
      #puts "Found #{obstructors.size} things in the way"
      return obstructors.any?
    when 'diag'
      dx = dest_x - pos_x
      ndx = dx / dx.abs
      dy = dest_y - pos_y
      ndy = dy / dy.abs
      #puts "ndx: #{ndx}, ndy: #{ndy}"
      cx = pos_x + ndx
      cy = pos_y + ndy
      while cx != dest_x do
        #puts "cx: #{cx}, cy: #{cy}"
        obstructors = game.pieces.where(pos_x: cx).where(pos_y: cy)
        #puts "Found something in the way" unless obstructors.size.zero?
        return true if obstructors.any?
        cx += ndx
        cy += ndy
      end
      return false
    when 'no_move'
      return false
    end

    puts "Unexpected move type: #{movement}"
    false
  end

  private

  def move_type(dest_x, dest_y)
    dx = (dest_x - pos_x).abs
    dy = (dest_y - pos_y).abs
    #puts "dx: #{dx}, dy: #{dy}"
    return 'no_move' if (dx + dy).zero?

    move_type = 'unchecked'
    move_type = 'vert' if dx.zero?
    move_type = 'horiz' if dy.zero?
    move_type = 'diag' if dx == dy
    move_type
  end
end

# Formerly the piece was called the tower
class Rook < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    dx = dest_x - pos_x
    dy = dest_y - pos_y
    return false unless dx.zero? || dy.zero?
    return false if obstructed?(dest_x, dest_y)
    true
  end
end

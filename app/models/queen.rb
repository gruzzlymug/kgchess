# The most powerful piece in the game
class Queen < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    udx = (dest_x - pos_x).abs
    udy = (dest_y - pos_y).abs
    return false unless udx == udy || udx.zero? || udy.zero?
    true
  end
end

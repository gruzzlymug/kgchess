# The pawn historically represents infantry, armed peasants or pikemen
class Pawn < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    dx = dest_x - pos_x
    return false unless dx.zero?
    return false if obstructed?(dest_x, dest_y)
    true
  end
end

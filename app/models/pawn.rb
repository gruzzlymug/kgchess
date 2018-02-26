# The pawn historically represents infantry, armed peasants or pikemen
class Pawn < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    dx = dest_x - pos_x
    return false unless dx.zero?

    # TODO: pawn can still go backwards
    udy = (dest_y - pos_y).abs
    return false if moves > 0 && udy != 1
    return false if moves.zero? && udy > 2
    return false if obstructed?(dest_x, dest_y)
    true
  end
end

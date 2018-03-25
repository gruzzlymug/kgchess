# The pawn historically represents infantry, armed peasants or pikemen
class Pawn < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)

    dx = dest_x - pos_x
    return false if dx.abs > 1
    udy = (dest_y - pos_y).abs
    if dx.zero?
      # TODO: pawn can still go backwards
      # TODO: pawn can jump pieces on first 2 square move
      return false if moves.positive? && udy != 1
      return false if moves.zero? && udy > 2
      blocker = game.piece_at(dest_x, dest_y)
      return false unless blocker.nil?
    else
      return false unless udy == 1
      blocker = game.piece_at(dest_x, dest_y)
      return false if blocker.nil?
      return false unless blocker.opponent?(player_id)
    end
    true
  end
end

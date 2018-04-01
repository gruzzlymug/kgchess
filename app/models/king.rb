# The most important piece
class King < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    dx = dest_x - pos_x
    udx = dx.abs
    dy = dest_y - pos_y
    if udx > 1 && dy.zero? && moves.zero?
      rook_x = dest_x + (dx / udx)
      return valid_castle?(dest_x, dest_y, rook_x)
    end
    return false unless dx.abs <= 1 && dy.abs <= 1
    true
  end

  def move_to(dest_x, dest_y)
    try_castle(dest_x, dest_y) if moves.zero?
    super(dest_x, dest_y)
  end

  def in_check?
    game.opponent_can_attack?(player_id, pos_x, pos_y)
  end

  private

  def valid_castle?(dest_x, dest_y, rook_x)
    return false if obstructed?(dest_x, dest_y)
    rook = game.piece_at(rook_x, dest_y)
    return false if rook.nil?
    return false unless rook.moves.zero?
    true
  end

  # TODO: move to game
  def try_castle(dest_x, dest_y)
    dx = dest_x - pos_x
    udx = dx.abs
    return unless udx > 1
    ndx = dx / udx
    rook_x = dest_x + ndx
    rook = game.piece_at(rook_x, dest_y)
    rook.update!(pos_x: dest_x - ndx, moves: rook.moves + 1)
  end
end

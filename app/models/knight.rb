class Knight < Piece
  def valid_move?(dest_x, dest_y)
    return false unless super(dest_x, dest_y)
    udx = (dest_x - pos_x).abs
    udy = (dest_y - pos_y).abs
    return false unless (udx == 2 && udy == 1) || (udx == 1 && udy == 2)
    true
  end
end

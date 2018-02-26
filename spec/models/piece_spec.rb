require 'rails_helper'

describe Pawn do
  context "has not moved" do
    it "can move 2 spaces forward" do
      g = create(:game)
      black = create(:player)
      g.join(black.id)
      pawn = g.white_pieces.where(type: 'Pawn').first
      expect(pawn.moves).to be(0)
      dest_x = pawn.pos_x
      dest_y = pawn.pos_y - 2
      expect(pawn.valid_move?(dest_x, dest_y)).to be(true)
    end
  end
end

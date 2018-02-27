require 'rails_helper'

describe Piece do
  before do
    @game = create(:game)
    black = create(:player)
    @game.join(black.id)
  end

  describe Pawn do
    describe '#valid_move?' do
      context 'on the first move' do
        before do
          @pawn = @game.white_pieces.where(type: 'Pawn').first
          expect(@pawn.moves).to be(0)
        end

        it 'can move 1 space forward' do
          dest_x = @pawn.pos_x
          dest_y = @pawn.pos_y - 1
          expect(@pawn.valid_move?(dest_x, dest_y)).to be(true)
        end

        it 'can move 2 spaces forward' do
          dest_x = @pawn.pos_x
          dest_y = @pawn.pos_y - 2
          expect(@pawn.valid_move?(dest_x, dest_y)).to be(true)
        end
      end
    end
  end
end

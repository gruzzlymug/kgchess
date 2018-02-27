require 'rails_helper'

describe Piece do
  before do
    @game = create(:game)
    black = create(:player)
    @game.join(black.id)
  end

  describe Pawn do
    before do
      @pawn = @game.white_pieces.where(type: 'Pawn').first
    end

    describe '#valid_move?' do
      context 'on the first move' do
        before do
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

  describe Rook do
    describe '#valid_move?' do
      context 'given an obstructing piece' do
        it 'cannot move' do
          rook = @game.piece_at(0, 0)
          expect(rook.valid_move?(0, 3)).to be(false)
        end
      end
    end
  end

  describe Knight do
    describe '#valid_move?' do
    end
  end

  describe Bishop do
    describe '#valid_move?' do
      context 'given an obstructing piece' do
        it 'cannot move' do
          bishop = @game.piece_at(2, 0)
          expect(bishop.valid_move?(5, 3)).to be(false)
        end
      end
    end
  end
end

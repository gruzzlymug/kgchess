require 'rails_helper'

describe Piece do
  let(:game) { create(:game_with_one_player) }
  let(:empty_game) { create(:game_with_two_players) }

  before do
    black = create(:player)
    game.join(black.id)
  end

  describe '#valid_move?' do
    context 'every move' do
      it 'must be on the board' do
        game = create(:game_with_two_players)
        piece = game.add_white_piece('Piece', 3, 3)
        expect(piece.valid_move?(3, 9)).to be(false)
        expect(piece.valid_move?(9, 3)).to be(false)
        expect(piece.valid_move?(3, -1)).to be(false)
        expect(piece.valid_move?(-1, 3)).to be(false)
        expect(piece.valid_move?(3, 0)).to be(true)
      end
    end
  end
end

describe Pawn do
  let(:game) { create(:game_with_one_player) }

  before do
    black = create(:player)
    game.join(black.id)
  end

  describe '#valid_move?' do
    context 'on the first move' do
      let(:pawn) { game.white_pieces.where(type: 'Pawn').first }

      before(:each) do
        expect(pawn.moves).to be(0)
      end

      it 'can move 1 space forward' do
        dest_x = pawn.pos_x
        dest_y = pawn.pos_y - 1
        expect(pawn.valid_move?(dest_x, dest_y)).to be(true)
      end

      it 'can move 2 spaces forward' do
        dest_x = pawn.pos_x
        dest_y = pawn.pos_y - 2
        expect(pawn.valid_move?(dest_x, dest_y)).to be(true)
      end
    end

    context 'when attacking' do
      let(:pawn) { game.add_white_piece('Pawn', 3, 4) }

      it 'can capture ahead and to the left' do
        opponent = game.add_black_piece('Pawn', 2, 3)
        expect(pawn.valid_move?(2, 3)).to be(true)
      end

      it 'can capture ahead and to the right' do
        opponent = game.add_black_piece('Pawn', 4, 3)
        expect(pawn.valid_move?(4, 3)).to be(true)
      end
    end
  end
end

describe Rook do
  before do
    @game = create(:game_with_one_player)
    black = create(:player)
    @game.join(black.id)

    @empty_game = create(:game_with_two_players)
  end

  describe '#valid_move?' do
    context 'given an obstructing piece' do
      it 'cannot move' do
        rook = @game.piece_at(0, 0)
        expect(rook.valid_move?(0, 3)).to be(false)
      end
    end

    context 'given an open board' do
      it 'can move up' do
        rook = @empty_game.add_white_piece('Rook', 0, 7)
        expect(rook.valid_move?(0, 3)).to be(true)
      end

      it 'can move down' do
        rook = @empty_game.add_white_piece('Rook', 3, 3)
        expect(rook.valid_move?(3, 7)).to be(true)
      end
    end

    context 'given a capturable enemy' do
      it 'can capture it' do
        rook = @empty_game.add_white_piece('Rook', 3, 6)
        enemy = @empty_game.add_black_piece('Pawn', 3, 3)
        expect(rook.valid_move?(enemy.pos_x, enemy.pos_y)).to be(true)
      end
    end
  end
end

describe Knight do
  describe '#valid_move?' do
  end
end

describe Bishop do
  before do
    @game = create(:game_with_one_player)
    black = create(:player)
    @game.join(black.id)

    @bishop = @game.piece_at(2, 0)
  end

  describe '#valid_move?' do
    context 'given an obstructing piece' do
      it 'cannot move' do
        expect(@bishop.valid_move?(5, 3)).to be(false)
      end
    end
  end
end

describe King do
  describe '#valid_move?' do
    it 'can castle to the left' do
      game = create(:game_with_two_players)
      king = game.add_white_piece('King', 4, 7)
      rook = game.add_white_piece('Rook', 0, 7)
      expect(king.valid_move?(1, 7)).to be(true)
    end

    it 'can castle to the right' do
      game = create(:game_with_two_players)
      king = game.add_white_piece('King', 4, 7)
      rook = game.add_white_piece('Rook', 7, 7)
      expect(king.valid_move?(6, 7)).to be(true)
    end
  end
end

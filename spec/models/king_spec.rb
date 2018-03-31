require 'rails_helper'

describe King do
  describe '#valid_move?' do
    let(:game) { create(:game_with_two_players) }
    let(:king) { game.add_white_piece('King', 4, 7) }

    it 'cannot move into check' do
      rook = game.add_black_piece('Rook', 3, 0)
      expect(king.valid_move?(3, 7)).to be(false)
    end

    it 'can castle to the left' do
      rook = game.add_white_piece('Rook', 0, 7)
      expect(king.valid_move?(1, 7)).to be(true)
    end
  
    it 'can castle to the right' do
      rook = game.add_white_piece('Rook', 7, 7)
      expect(king.valid_move?(6, 7)).to be(true)
    end
  end
end

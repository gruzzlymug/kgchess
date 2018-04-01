require 'rails_helper'

describe Game do
  let(:game) { create(:game_with_one_player) }
  let(:empty_game) { create(:game_with_two_players) }
  let(:black_player) { create(:player) }

  context 'when created' do
    it 'must have a white player' do
      expect(game.white_player).to be_instance_of(Player)
    end

    it 'should be joinable' do
      expect(game.joinable?(black_player)).to be(true)
    end
  end

  context 'after second player joins' do
    it 'should be the white player\'s turn' do
      game.join(black_player.id)
      expect(game.player_turn).to equal(game.white_player_id)
    end
  end

  context 'after a piece is captured' do
    it 'should be removed from the board' do
      rook = empty_game.add_white_piece('Rook', 3, 6)
      victim = empty_game.add_black_piece('Bishop', 3, 3)
      empty_game.select_piece(rook.id)
      empty_game.move_selected_piece(victim.pos_x, victim.pos_y)
      victim.reload
      expect(victim.pos_x).to be(nil)
      expect(victim.pos_y).to be(nil)
    end
  end

  it 'supports castle' do
    king = empty_game.add_white_piece('King', 4, 7)
    rook = empty_game.add_white_piece('Rook', 7, 7)
    empty_game.select_piece(king.id)
    empty_game.move_selected_piece(6, 7)
    king.reload
    rook.reload
    expect(king.pos_x).to eq(6)
    expect(rook.pos_x).to eq(5)
  end

  it 'does not allow other moves to put king in check' do
    empty_game.add_white_piece('King', 4, 7)
    empty_game.add_black_piece('Queen', 4, 0)
    blocker = empty_game.add_white_piece('Bishop', 4, 6)
    expect(empty_game.valid_move?(blocker.id, 3, 5)).to be(false)
  end
end

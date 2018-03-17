require 'rails_helper'

describe Game do
  context 'when created' do
    it 'must have a white player' do
      g = create(:game_with_one_player)
      expect(g.white_player).to be_instance_of(Player)
    end

    it 'should be joinable' do
      g = create(:game_with_one_player)
      black_player = create(:player)
      expect(g.joinable?(black_player)).to be(true)
    end
  end

  context 'after second player joins' do
    it 'should be the white player\'s turn' do
      g = create(:game_with_one_player)
      black_player = create(:player)
      g.join(black_player.id)
      expect(g.player_turn).to equal(g.white_player_id)
    end
  end

  context 'after a piece is captured' do
    it 'should be removed from the board' do
      empty_game = create(:game_with_two_players)
      rook = empty_game.add_white_piece('Rook', 3, 6)
      victim = empty_game.add_black_piece('Bishop', 3, 3)
      empty_game.select_piece(rook.player_id, rook.id)
      empty_game.move_selected_piece(rook.player_id, victim.pos_x, victim.pos_y)
      victim.reload
      expect(victim.pos_x).to be(nil)
      expect(victim.pos_y).to be(nil)
    end
  end
end

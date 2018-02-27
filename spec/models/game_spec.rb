require 'rails_helper'

describe Game do
  context 'when created' do
    it 'must have a white player' do
      g = create(:game)
      expect(g.white_player).to be_instance_of(Player)
    end

    it 'should be joinable' do
      g = create(:game)
      black_player = create(:player)
      expect(g.joinable?(black_player)).to be(true)
    end
  end

  context 'after second player joins' do
    it 'should be the white player\'s turn' do
      g = create(:game)
      black_player = create(:player)
      g.join(black_player.id)
      expect(g.player_turn).to equal(g.white_player_id)
    end
  end
end

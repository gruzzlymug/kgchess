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
end

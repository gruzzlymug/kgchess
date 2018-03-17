require 'rails_helper'
require 'spec_helper'

describe GamesController do
  before do
    @game = create(:game_with_one_player)
    black = create(:player)
    @game.join(black.id)

    @player = @game.white_player
    sign_in @player
  end

  describe 'GET #index' do
    context 'when all is well' do
      it 'will return a list of games' do
        get :index
        expect(response).to be_success
      end
    end
  end
end

require 'test_helper'

# To run tests: spring rake test
class GameTest < ActiveSupport::TestCase
  test 'should be joinable' do
    g = games(:game_one)
    p = players(:player_one)
    assert g.joinable?(p.id)
  end
end

class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'
end

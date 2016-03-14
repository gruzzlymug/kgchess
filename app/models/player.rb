class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :white_games, class_name: 'Game', foreign_key: :white_player_id
  has_many :black_games, class_name: 'Game', foreign_key: :black_player_id

  def games
    white_games + black_games
  end
end

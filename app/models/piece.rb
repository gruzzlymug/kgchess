# Base class for STI chess piece models
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def obstructed?(dest_x, dest_y)
    true
  end
end

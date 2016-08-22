# Auto-generated helper
module GamesHelper
  def piece_html(type, is_white)
    case type
    when 'Bishop'
      is_white ? '&#9815;' : '&#9821;'
    when 'Knight'
      is_white ? '&#9816;' : '&#9822;'
    when 'Pawn'
      is_white ? '&#9817;' : '&#9823;'
    when 'Rook'
      is_white ? '&#9814;' : '&#9820;'
    when 'Queen'
      is_white ? '&#9813;' : '&#9819;'
    when 'King'
      is_white ? '&#9812;' : '&#9818;'
    else
      is_white ? '?' : '!'
    end
  end
end

# Auto-generated helper
module GamesHelper
  def piece_html(type, is_white)
    code = piece_code(type)
    code += 6 unless is_white
    "&##{code};"
  end

  private

  def piece_code(type)
    idx = %w[King Queen Rook Bishop Knight Pawn].index(type)
    9812 + idx
  end

  # TODO: profile vs current method (this one is too complex for rubocop)
  # def piece_code_old(type)
  #   case type
  #   when 'King'   then 9812
  #   when 'Queen'  then 9813
  #   when 'Rook'   then 9814
  #   when 'Bishop' then 9815
  #   when 'Knight' then 9816
  #   when 'Pawn'   then 9817
  #   end
  # end
end

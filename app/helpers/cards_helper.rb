# app/helpers/cards_helper.rb
module CardsHelper
  def color_gradient(color)
    case color
    when "dark" then "linear-gradient(135deg,#1C1108,#2D1B06)"
    when "amber" then "linear-gradient(135deg,#92400E,#B45309)"
    when "green" then "linear-gradient(135deg,#14532D,#166534)"
    when "navy" then "linear-gradient(135deg,#1E293B,#334155)"
    when "wine" then "linear-gradient(135deg,#4C1D2F,#7F1D3F)"
    when "slate" then "linear-gradient(135deg,#E8E0D4,#D5C9BA)"
    else "#fff"
    end
  end
end

# frozen_string_literal: true

class Users::DashboardController < ApplicationController
	before_action :authenticate_user!
	
	def index
    @user_card = current_user.user_cards.first
    @card = @user_card&.card
    @stamps = @user_card&.stamps
    
    count = @stamps&.count.to_i
    max = @card&.reward_rule.to_i
    @how_many_stamps_on_user_card = 
      if max > 0 && count % max == 0 && count > 0
        max
      elsif max > 0
        count % max
      else
        0
      end
    @empty_stamps = @card&.reward_rule - @how_many_stamps_on_user_card rescue nil
    @last_4_stamps = @user_card&.stamps&.last(3)
    @coupons = current_user.coupons.last(3)
	end

  def your_card
    @user_card = current_user.user_cards.first
    @card = @user_card&.card
  end

  def qr
    require "rqrcode"

    user_card = current_user.user_cards.find(params[:id])
    token = user_card.token
  
    qr = RQRCode::QRCode.new(customers_scan_url(token: token))
  
    png = qr.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      fill: "white",
      size: 700
    )
  
    send_data png.to_s,
              type: "image/png",
              disposition: "inline"
  end

  def help
  end
end

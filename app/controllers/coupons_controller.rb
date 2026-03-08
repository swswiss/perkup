class CouponsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :activities, :show, :qr]
  before_action :authenticate_customer!, only: [:check, :redeem]

  def index
    @coupons = current_user.coupons
  end

  def activities
    @stamps = current_user.user_cards.first.stamps
  end

  def show
  end
  
  def check
    @coupon = Coupon.find_by!(code: params[:token])
  end

  def qr
    require "rqrcode"
    coupon = current_user.coupons.find(params[:id])
    token = coupon.code

    qr = RQRCode::QRCode.new(check_coupons_url(token: token))

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

  def redeem
    @coupon = Coupon.find_by!(code: params[:token])
  
    if @coupon.used?
      redirect_to check_coupons_path(token: @coupon.code), alert: "Coupon already used"
    elsif @coupon.expires_at < Time.current
      redirect_to check_coupons_path(token: @coupon.code), alert: "Coupon expired"
    else
      @coupon.update!(used: true, used_at: Time.current)
      redirect_to check_coupons_path(token: @coupon.code), notice: "Coupon redeemed"
    end
  end  
end

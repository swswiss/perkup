class Customers::CardsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_card, only: [:show, :edit, :update, :destroy, :live_qrcode]

  def index
    @cards = current_customer.cards
  end

  def show
  end

  def new
    @card = current_customer.cards.build
  end

  def create
    @card = current_customer.cards.build(card_params)
    @card.color = params[:theme]

    # later i will add index unique on customer_id and validates :customer_id, uniqueness: true
    if current_customer.cards.exists?
      redirect_to customers_cards_path, alert: "Could not create card: You have already one!"
    elsif @card.save
      redirect_to customers_cards_path, notice: "Card \"#{@card.name}\" created successfully!"
    else
      redirect_to customers_cards_path, alert: "Could not create card: #{@card.errors.full_messages.to_sentence}"
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to customers_cards_path, notice: "Card updated successfully."
    else
      render :edit
    end
  end

  def destroy
    # @card.destroy
    # flash.now[:success] = "Card \"#{@card.name}\" destroyed!"
    # respond_to do |format|
    #   format.turbo_stream do
    #     render turbo_stream: [
    #       turbo_stream.remove("card_#{@card.id}"),
    #       turbo_stream.update("flash-container", partial: "customers/shared/flash_messages")
    #     ]
    #   end
    #   format.html { redirect_to customers_cards_path, notice: "Card destroyed!" }
    # end
  end

  def live_qrcode
    @token = SecureRandom.hex(16)
    MyRedis.instance.set("scan_token:#{@token}", @card.id, ex: 60)
  end

  def qr
    require "rqrcode"
    card = current_customer.cards.find(params[:id])

    token = params[:token]
    qr = RQRCode::QRCode.new(users_scan_url(token: token))

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

  def print_qr
    require "rqrcode"
    card = current_customer.cards.find(params[:id])

    token = card.uuid
    qr = RQRCode::QRCode.new(users_scan_create_user_card_url(token))

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

  private

  def set_card
    @card = current_customer.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:name, :reward_rule, :product, :reward, :description, :color, :how_many)
  end  
end

class Users::ScansController < ApplicationController
  before_action :authenticate_user!

  def show
    token = params[:token]
    binding.pry
    card_id = MyRedis.instance.get("scan_token:#{token}")
    binding.pry
    if card_id.nil?
      render plain: "QR expired or invalid", status: :forbidden
      return
    end

    # Invalidate immediately (one-time use)
    binding.pry
    MyRedis.instance.del("scan_token:#{token}")
    binding.pry
    card = Card.find(card_id)
    user_card = UserCard.find_or_create_by(user: current_user, card: card)

    user_card.increment!(:points)

    render plain: "Points added!"
  end
end
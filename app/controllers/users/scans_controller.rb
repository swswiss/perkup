class Users::ScansController < ApplicationController
  before_action :authenticate_user!

  def show
    token = params[:token]
    card_id = MyRedis.instance.get("scan_token:#{token}")

    if card_id.nil?
      render plain: "QR expired or invalid", status: :forbidden
      return
    end

    # Invalidate immediately (one-time use)
    MyRedis.instance.del("scan_token:#{token}")

    card = Card.find(card_id)
    user_card = UserCard.find_or_create_by(user: current_user, card: card)
    stamp = Stamp.create(user_card_id: user_card.id, scan_token: token) if user_card && token
    return unless stamp.persisted?

    user_card.increment!(:points)
    create_coupon(user_card, )

    render plain: "Points added!"
  end

  private

  def create_coupon(user_card, card)
    if user_card.stamps.count % card.reward_rule == 0
      Coupon.create(user_id: current_user.id, card_id: card.id, used: false)
    end
  end
end
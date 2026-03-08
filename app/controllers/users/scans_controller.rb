class Users::ScansController < ApplicationController
  before_action :authenticate_user!

  def show
    token = params[:token]
    card_id = MyRedis.instance.get("scan_token:#{token}")

    if card_id.nil?
      return redirect_to users_scan_expired_path
    end

    # Invalidate immediately (one-time use)
    MyRedis.instance.del("scan_token:#{token}")

    card = Card.find(card_id)
    user_card = UserCard.find_or_create_by(user: current_user, card: card)
    stamp = Stamp.create(user_card_id: user_card.id, scan_token: token) if user_card && token
    return unless stamp.persisted?

    user_card.increment!(:points)
    coupon = create_coupon(user_card, card)

    if coupon
      redirect_to users_scan_reward_path(card_id: card.id, coupon_id: coupon.id)
    else
      redirect_to users_scan_success_path(card_id: card.id)
    end
  end

  def success
    @card = Card.find(params[:card_id])
    @user_card = UserCard.find_by(user: current_user, card: @card)
    @stamps = @user_card.points
    @total = @card.reward_rule
    @remaining = @total - @stamps
  end

  def reward
  end

  def expired
  end

  private

  def create_coupon(user_card, card)
    if user_card.stamps.count % card.reward_rule == 0
      Coupon.create(user_id: current_user.id, card_id: card.id, used: false)
    end
  end
end
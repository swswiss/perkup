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
    notify_user_stamp(user_card.user, card)
    stamp = Stamp.create(user_card_id: user_card.id, scan_token: token) if user_card && token
    return unless stamp.persisted?

    user_card.increment!(:points)
    created = create_coupon(user_card, card)

    if created
      redirect_to users_scan_reward_path(card_id: card.id)
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

  def create_user_card
    token = params[:token]
  
    card = Card.find_by(uuid: token)
    user_card = UserCard.find_or_create_by(user: current_user, card: card)
    redirect_to root_path
  end

  private

  def notify_user_stamp(user, card)  
    OnesignalService.send_to_user(user, title: "titlu nebun", message: "mesaj nebun", url: nil)                                                                                                          
  end

  def create_coupon(user_card, card)
    return false unless user_card.stamps.count % card.reward_rule == 0

    card.how_many.times do
      Coupon.create(user_id: current_user.id, card_id: card.id, used: false)
    end

    true
  end
end
class Customers::ScansController < ApplicationController
  before_action :authenticate_customer!

  def show
    token = params[:token]
    user_card = current_customer.user_cards.find_by(token: token)

    if user_card.nil?
      return redirect_to customers_scan_expired_path
    end

    card = user_card&.card
    stamp = Stamp.create(user_card_id: user_card.id, scan_token: SecureRandom.hex(16)) if user_card && token
    return redirect_to customers_scan_expired_path unless stamp.persisted?

    user_card.increment!(:points)
    created = create_coupon(user_card, card)

    if created
      redirect_to customers_scan_reward_path(card_id: card.id)
    else
      redirect_to customers_scan_success_path(card_id: card.id)
    end
  end

  def success
  end

  def reward
  end

  def expired
  end

  private

  def create_coupon(user_card, card)
    return false unless user_card.stamps.count % card.reward_rule == 0
    current_user = user_card.user

    card.how_many.times do
      Coupon.create(user_id: current_user.id, card_id: card.id, used: false)
    end

    true
  end
end
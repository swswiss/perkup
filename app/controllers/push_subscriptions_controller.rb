class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(endpoint: params[:endpoint])
    subscription.p256dh = params.dig(:keys, :p256dh)
    subscription.auth   = params.dig(:keys, :auth)
    subscription.save!

    head :ok
  end

  def destroy
    current_user.push_subscriptions.where(endpoint: params[:endpoint]).destroy_all
    head :ok
  end
end

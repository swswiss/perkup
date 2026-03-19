class PushSubscriptionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    subscription = current_user.push_subscriptions.create!(
      endpoint: params[:endpoint],
      p256dh: params.dig(:keys, :p256dh),
      auth: params.dig(:keys, :auth)
    )
    head :ok
  end
end

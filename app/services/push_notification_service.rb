# app/services/push_notification_service.rb
class PushNotificationService
  def self.call(user:, title:, body:, url: '/')
    new(user, title, body, url).call
  end

  def initialize(user, title, body, url)
    @user = user
    @title = title
    @body = body
    @url = url
  end

  def call
    @user.push_subscriptions.find_each do |sub|
      send_notification(sub)
    end
  end

  private

  def send_notification(sub)
    WebPush.payload_send(
      message: payload.to_json,
      endpoint: sub.endpoint,
      p256dh: sub.p256dh,
      auth: sub.auth,
      vapid: vapid_keys
    )
  rescue => e
    Rails.logger.error("Push failed for subscription #{sub.id}: #{e.message}")
  end

  def payload
    {
      title: @title,
      body: @body,
      url: @url
    }
  end

  def vapid_keys
    {
      subject: 'mailto:admin@yourapp.com',
      public_key: Rails.application.credentials.dig(:webpush, :public_key),
      private_key: Rails.application.credentials.dig(:webpush, :private_key)
    }
  end
end

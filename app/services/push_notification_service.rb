require "web-push"

class PushNotificationService
  Result = Struct.new(:sent, :failed, :expired, keyword_init: true)

  def self.broadcast(title:, body:, url: "/")
    new(PushSubscription.all, title: title, body: body, url: url).deliver
  end

  def self.deliver_to(user, title:, body:, url: "/")
    new(user.push_subscriptions, title: title, body: body, url: url).deliver
  end

  def initialize(subscriptions, title:, body:, url:)
    @subscriptions = subscriptions
    @title = title
    @body = body
    @url = url
  end

  def deliver
    result = Result.new(sent: 0, failed: 0, expired: 0)

    @subscriptions.find_each do |sub|
      WebPush.payload_send(
        message: payload.to_json,
        endpoint: sub.endpoint,
        p256dh: sub.p256dh,
        auth: sub.auth,
        vapid: vapid
      )
      result.sent += 1
    rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription
      sub.destroy
      result.expired += 1
    rescue => e
      Rails.logger.error("Web push failed for subscription #{sub.id}: #{e.class} #{e.message}")
      result.failed += 1
    end

    result
  end

  private

  def payload
    { title: @title, body: @body, url: @url }
  end

  def vapid
    {
      subject: Perkup::VAPID[:subject],
      public_key: Perkup::VAPID[:public_key],
      private_key: Perkup::VAPID[:private_key]
    }
  end
end

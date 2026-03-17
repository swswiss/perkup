class OnesignalService
  BASE_URL = "https://onesignal.com/api/v1/notifications".freeze

  def self.send_to_user(user, title:, message:, url: nil)
    return unless ONESIGNAL_CONFIG[:app_id] && ONESIGNAL_CONFIG[:api_key]

    body = {
      app_id: ONESIGNAL_CONFIG[:app_id],
      include_external_user_ids: [user.id.to_s],
      headings: { en: title },
      contents: { en: message }
    }
    body[:url] = url if url

    HTTParty.post(
      BASE_URL,
      headers: {
        "Authorization" => "Basic #{ONESIGNAL_CONFIG[:api_key]}",
        "Content-Type" => "application/json"
      },
      body: body.to_json
    )
  rescue StandardError => e
    Rails.logger.error("OneSignal notification failed: #{e.message}")
  end
end

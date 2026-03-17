class OnesignalService
  BASE_URL = "https://api.onesignal.com/notifications".freeze
                                                                                                                   
  def self.send_to_user(user, title:, message:, url: nil)                                                          
    return unless ONESIGNAL_CONFIG[:app_id] && ONESIGNAL_CONFIG[:api_key]                                          
                                                                                                                   
    body = {    
      app_id: ONESIGNAL_CONFIG[:app_id],                                                                           
      include_aliases: { external_id: [user.id.to_s] },
      target_channel: "push",                                                                                      
      headings: { en: title },                                                                                     
      contents: { en: message }                                                                                    
    }                                                                                                              
    body[:url] = url if url

    HTTParty.post(                                                                                                 
      BASE_URL,
      headers: {                                                                                                   
        "Authorization" => "Key #{ONESIGNAL_CONFIG[:api_key]}",
        "Content-Type" => "application/json"
      },                                                                                                           
      body: body.to_json
    )                                                                                                              
  rescue StandardError => e
    Rails.logger.error("OneSignal notification failed: #{e.message}")
  end                                                                                                              
end
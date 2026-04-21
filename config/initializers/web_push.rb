require "yaml"

module Perkup
  VAPID = if Rails.env.production?
    {
      public_key: ENV["VAPID_PUBLIC_KEY"],
      private_key: ENV["VAPID_PRIVATE_KEY"]
    }
  else
    path = Rails.root.join("config", "vapid.yml")
    raw = YAML.load_file(path, aliases: true)
    raw[Rails.env] || raw["default"] || {}
  end.with_indifferent_access.freeze
end

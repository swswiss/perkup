require "yaml"

module Perkup
  VAPID = begin
    path = Rails.root.join("config", "vapid.yml")
    raw = YAML.load_file(path, aliases: true)
    raw[Rails.env] || raw["default"] || {}
  rescue Errno::ENOENT
    {}
  end.with_indifferent_access.freeze
end

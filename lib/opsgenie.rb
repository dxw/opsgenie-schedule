require "httparty"

require "opsgenie/client"
require "opsgenie/schedule"
require "opsgenie/rotation"
require "opsgenie/user"
require "opsgenie/config"

module Opsgenie
  def self.configure(api_key:)
    Opsgenie::Config.configure(api_key)
  end

  class ConfigurationError < StandardError; end
end

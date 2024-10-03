module Opsgenie
  class Client
    ROOT_PATH = "https://api.opsgenie.com".freeze

    class << self
      def get(path)
        url = [
          ROOT_PATH,
          version,
          path
        ].join("/")
        HTTParty.get(url, headers)
      end

      def headers
        {
          headers: auth_header
        }
      end

      def auth_header
        {"Authorization" => "GenieKey #{api_key}"}
      end

      def version
        "v2"
      end

      def api_key
        raise ConfigurationError.new("Missing API key. Use `Opsgenie.configure(api_key: YOUR_API_KEY)` to set the API key") if Config.opsgenie_api_key.nil?

        Config.opsgenie_api_key
      end
    end
  end
end

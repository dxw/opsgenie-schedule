module Opsgenie
  class Client
    ROOT_PATH = "https://api.opsgenie.com".freeze
    API_KEY = ENV["OPSGENIE_API_KEY"]

    class << self
      def get(path)
        url = [
          ROOT_PATH,
          version,
          path,
        ].join("/")
        HTTParty.get(url, headers)
      end

      def headers
        {
          headers: auth_header,
        }
      end

      def auth_header
        {"Authorization" => "GenieKey #{API_KEY}"}
      end

      def version
        "v2"
      end
    end
  end
end

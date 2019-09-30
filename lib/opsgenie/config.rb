module Opsgenie
  class Config
    class << self
      attr_reader :opsgenie_api_key

      def configure(opsgenie_api_key)
        @opsgenie_api_key = opsgenie_api_key
        self
      end
    end
  end
end

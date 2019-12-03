require "date"

module Opsgenie
  class User
    class << self
      def all
        body = Opsgenie::Client.get("users?limit=500")
        body["data"].map { |s| new(s) }
      end
    end

    attr_reader :id, :username, :full_name

    def initialize(attrs)
      @id = attrs["id"]
      @username = attrs["username"]
      @full_name = attrs["fullName"]
    end
  end
end

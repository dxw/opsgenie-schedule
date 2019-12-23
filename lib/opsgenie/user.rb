require "date"

module Opsgenie
  class User
    class << self
      def all
        body = Opsgenie::Client.get("users?limit=500")
        body["data"].map { |s| new(s) }
      end

      def find_by_username(username)
        find_by(:username, username)
      end

      def find(id)
        find_by(:id, id)
      end

      private

      def find_by(key, value)
        @users ||= all
        @users.find { |user| user.send(key) == value }
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

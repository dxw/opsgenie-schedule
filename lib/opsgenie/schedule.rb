module Opsgenie
  class Schedule
    attr_reader :id, :name

    class << self
      def all
        body = Opsgenie::Client.get("schedules")
        body["data"].map { |s| new(s) }
      end

      def find(id)
        body = Opsgenie::Client.get("schedules/#{id}")
        new(body["data"])
      end
    end

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
    end
  end
end

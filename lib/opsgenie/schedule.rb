module Opsgenie
  class Schedule
    class << self
      def all
        body = Opsgenie::Client.get("schedules")
        body["data"].map { |s| new(s) }
      end
    end

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
    end
  end
end

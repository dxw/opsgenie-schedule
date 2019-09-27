require "date"

module Opsgenie
  class Schedule
    attr_reader :id, :name

    class << self
      def all
        body = Opsgenie::Client.get("schedules")
        body["data"].map { |s| new(s) }
      end

      def find_by_name(name)
        find(name, "name")
      end

      def find_by_id(id)
        find(id, "name")
      end

      def find(id_or_name, type = "id")
        body = Opsgenie::Client.get("schedules/#{id_or_name}?identifierType=#{type}")
        new(body["data"])
      end
    end

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
    end

    def on_calls(date = Date.today)
      datetime = "#{date}T10:00:00%2B00:00"
      endpoint = "schedules/#{id}/on-calls?date=#{datetime}"
      body = Opsgenie::Client.get(endpoint)
      get_participants(body).map { |u| u["name"] }
    end

    private

    def get_participants(body)
      body["data"]["onCallParticipants"].select do |p|
        p["type"] == "user"
      end
    end
  end
end

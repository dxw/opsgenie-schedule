require "date"

module Opsgenie
  class Schedule
    attr_reader :id, :name, :rotations

    class << self
      def all
        body = Opsgenie::Client.get("schedules?expand=rotation")
        body["data"].map { |s| new(s) }
      end

      def find_by_name(name)
        find(name, "name")
      end

      def find_by_id(id)
        find(id)
      end

      def find(id_or_name, type = "id")
        body = Opsgenie::Client.get("schedules/#{id_or_name}?identifierType=#{type}")
        new(body["data"]) unless body["data"].nil?
      end
    end

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @rotations = attrs["rotations"].map { |r| Rotation.new(self, r) }
    end

    def on_calls(datetime = nil)
      endpoint = "schedules/#{id}/on-calls"
      endpoint += "?date=#{escape_datetime(datetime)}" unless datetime.nil?
      body = Opsgenie::Client.get(endpoint)
      get_participants(body).map { |u| User.find_by_username(u["name"]) }
    end

    def timeline(date: Date.today, interval: nil, interval_unit: nil)
      check_interval_unit(interval_unit) if interval_unit

      datetime = date.to_datetime
      endpoint = "schedules/#{id}/timeline?date=#{escape_datetime(datetime)}"
      endpoint += "&interval=#{interval}" if interval
      endpoint += "&intervalUnit=#{interval_unit}" if interval_unit
      body = Opsgenie::Client.get(endpoint)
      body.dig("data", "finalTimeline", "rotations").map do |rotation|
        TimelineRotation.new(
          id: rotation["id"],
          name: rotation["name"],
          periods: rotation["periods"] || []
        )
      end
    end

    private

    def get_participants(body)
      body["data"]["onCallParticipants"].select do |p|
        p["type"] == "user"
      end
    end

    def escape_datetime(datetime)
      CGI.escape(datetime.to_s)
    end

    def check_interval_unit(value)
      return if valid_intervals.include?(value)

      raise ArgumentError, "`interval_unit` must be one of `#{valid_intervals}``"
    end

    def valid_intervals
      %i[days weeks months]
    end
  end
end

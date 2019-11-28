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
        find(id, "name")
      end

      def find(id_or_name, type = "id")
        body = Opsgenie::Client.get("schedules/#{id_or_name}?identifierType=#{type}")
        new(body["data"]) unless body["data"].nil?
      end
    end

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @rotations = attrs["rotations"].map { |r| Rotation.new(r) }
    end

    def on_calls(datetime = nil)
      endpoint = "schedules/#{id}/on-calls"
      endpoint += "?date=#{CGI.escape datetime.to_s}" unless datetime.nil?
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

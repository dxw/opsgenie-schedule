module Opsgenie
  class Rotation
    attr_reader :schedule,
      :id,
      :name,
      :time_restriction,
      :start_date,
      :type,
      :participants

    def initialize(schedule, attrs)
      @schedule = schedule
      @id = attrs["id"]
      @name = attrs["name"]
      @time_restriction = attrs["timeRestriction"]
      @start_date = DateTime.parse(attrs["startDate"])
      @type = attrs["type"]
      @participants = attrs["participants"]
    end

    def on_call_for_date(date)
      day_of_the_week = date.strftime("%A").downcase
      restriction = time_restriction["restrictions"].find { |r|
        r["startDay"] == day_of_the_week
      }

      return unless restriction

      time = Time.new(
        date.year,
        date.month,
        date.day,
        restriction["startHour"],
        restriction["startMin"]
      )

      on_calls = schedule.on_calls((time + 60).to_datetime)
      on_calls.select { |name| participant_usernames.include?(name) }
    end

    private

    def participant_usernames
      participants.map { |p| p["username"] }
    end
  end
end

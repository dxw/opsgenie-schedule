module Opsgenie
  class Rotation
    attr_reader :id,
      :name,
      :time_restriction,
      :start_date,
      :type,
      :participants

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @time_restriction = attrs["timeRestriction"]
      @start_date = DateTime.parse(attrs["startDate"])
      @type = attrs["type"]
      @participants = attrs["participants"]
    end
  end
end

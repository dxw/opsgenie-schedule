module Opsgenie
  class TimelineRotation
    attr_reader :id, :name, :periods

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @periods = attrs["periods"].map { |p| TimelinePeriod.new(p) }
    end
  end
end

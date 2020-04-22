module Opsgenie
  class TimelineRotation
    attr_reader :id, :name, :periods

    def initialize(id:, name:, periods:)
      @id = id
      @name = name
      @periods = periods.map { |p| TimelinePeriod.new(p) }
    end
  end
end

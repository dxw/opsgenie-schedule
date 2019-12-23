module Opsgenie
  class TimelinePeriod
    attr_reader :start_date, :end_date, :user
    def initialize(attrs)
      @start_date = DateTime.parse(attrs["startDate"])
      @end_date = DateTime.parse(attrs["endDate"])
      @user = Opsgenie::User.find(attrs["recipient"]["id"])
    end
  end
end

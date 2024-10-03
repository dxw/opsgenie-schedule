require "spec_helper"

RSpec.describe Opsgenie::TimelinePeriod do
  it "marshals a hash into a the correct shape" do
    stub_user_list_request
    attrs = {
      "startDate" => "2019-01-01T10:00:00Z",
      "endDate" => "2019-01-01T18:00:00Z",
      "recipient" => {
        "id" => "b5b92115-bfe7-43eb-8c2a-e467f2e5ddc4"
      }
    }
    period = Opsgenie::TimelinePeriod.new(attrs)
    expect(period.start_date).to eq(DateTime.parse(attrs["startDate"]))
    expect(period.end_date).to eq(DateTime.parse(attrs["endDate"]))
    expect(period.user.username).to eq("john.doe@opsgenie.com")
  end
end

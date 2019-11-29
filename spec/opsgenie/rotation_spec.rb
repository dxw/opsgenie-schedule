require "spec_helper"

RSpec.describe Opsgenie::Rotation do
  let(:rotation_attrs) do
    {
      "id" => "3d9295c6-748d-4bd4-a153-8fd559be0722",
      "name" => "Dev",
      "startDate" => "2019-10-23T09:00:00Z",
      "type" => "weekly",
      "length" => 1,
      "participants" => [],
      "timeRestriction" => {
        "type" => "weekday-and-time-of-day",
        "restrictions" => [
          {
            "startDay" => "monday",
            "endDay" => "monday",
            "startHour" => 10,
            "endHour" => 18,
            "startMin" => 0,
            "endMin" => 0,
          },
          {
            "startDay" => "tuesday",
            "endDay" => "tuesday",
            "startHour" => 10,
            "endHour" => 18,
            "startMin" => 0,
            "endMin" => 0,
          },
          {
            "startDay" => "thursday",
            "endDay" => "thursday",
            "startHour" => 10,
            "endHour" => 18,
            "startMin" => 0,
            "endMin" => 0,
          },
          {
            "startDay" => "friday",
            "endDay" => "friday",
            "startHour" => 10,
            "endHour" => 18,
            "startMin" => 0,
            "endMin" => 0,
          },
          {
            "startDay" => "wednesday",
            "endDay" => "wednesday",
            "startHour" => 10,
            "endHour" => 18,
            "startMin" => 0,
            "endMin" => 0,
          },
        ],
      },
    }
  end
  let(:rotation) { Opsgenie::Rotation.new(schedule, rotation_attrs) }
  let(:schedule) { Opsgenie::Schedule.new("id" => 123, "name" => "first_line", "rotations" => []) }

  it "initializes correctly" do
    expect(rotation.id).to eq(rotation_attrs["id"])
    expect(rotation.schedule).to eq(schedule)
  end

  describe "#on_call_for_date" do
    let(:on_calls) { rotation.on_call_for_date(date) }

    context "when the day is in the schedule" do
      let(:body) do
        {
          data: {
            _parent: {
              id: "e71d500f-896a-4b28-8b08-3bfe56e1ed76",
              name: "first_line",
              enabled: true,
            },
            onCallParticipants: [
              {
                id: "19e39115-07d5-4924-8295-332a66dd1569",
                name: "foo@example.com",
                type: "user",
              },
              {
                id: "acd9af98-e3c0-4588-8276-1c545911e44f",
                name: "bar@example.com",
                type: "user",
              },
              {
                id: "9de61103-0d61-4f86-9dbf-154bbdca9cd8",
                name: "baz@example.com",
                type: "user",
              },
            ],
          },
          took: 0.098,
          requestId: "0c607829-68d2-4aee-8e2a-10acd972f067",
        }
      end

      let(:date) { Date.parse("2019-11-29") }

      it "makes the correct API call" do
        url = "https://api.opsgenie.com/v2/schedules/123/on-calls?date=2019-11-29T10:01:00%2B00:00"

        stub = stub_request(:get, url)
          .to_return(status: 200,
                     body: body.to_json,
                     headers: {"Content-Type" => "application/json"})

        expect(on_calls).to eq(["foo@example.com", "bar@example.com", "baz@example.com"])
        expect(stub).to have_been_requested
      end
    end

    context "when the day is not in the schedule" do
      let(:date) { Date.parse("2019-11-30") }

      it "returns nil" do
        expect(on_calls).to eq(nil)
      end
    end
  end
end

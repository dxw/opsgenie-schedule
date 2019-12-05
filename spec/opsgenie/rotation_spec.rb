require "spec_helper"

RSpec.describe Opsgenie::Rotation do
  let(:rotation_attrs) do
    {
      "id" => "3d9295c6-748d-4bd4-a153-8fd559be0722",
      "name" => "Dev",
      "startDate" => "2019-10-23T09:00:00Z",
      "type" => "weekly",
      "length" => 1,
      "participants" => [
        {
          "id" => "19e39115-07d5-4924-8295-332a66dd1569",
          "username" => "john.doe@opsgenie.com",
          "type" => "user",
        },
      ],
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
                name: "john.doe@opsgenie.com",
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
        stub_user_list_request
        url = "https://api.opsgenie.com/v2/schedules/123/on-calls?date=2019-11-29T10:01:00%2B00:00"

        stub = stub_get_request(url, body)

        expect(on_calls.count).to eq(1)
        expect(on_calls.first.username).to eq("john.doe@opsgenie.com")

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

  describe "timeline" do
    let(:body) do
      {
        data: {
          finalTimeline: {
            rotations: [
              {
                id: "538465d7-67d0-4d3d-80e0-e2a07a2b5649",
                name: "OOH",
                order: 5.0,
                periods: [
                  {
                    startDate: "2019-11-06T18:00:00Z",
                    endDate: "2019-11-07T10:00:00Z",
                    type: "historical",
                    recipient: {
                      id: "8e3d055d-2b50-444d-ab89-d4353e831219",
                      type: "user",
                      name: "foo@example.com",
                    },
                    flattenedRecipients: [
                      {
                        id: "8e3d055d-2b50-444d-ab89-d4353e831219",
                        type: "user",
                        name: "foo@example.com",
                      },
                    ],
                  },
                ],
              },
              {
                id: "12339",
                name: "Dev",
                order: 5.0,
                periods: [
                  {
                    startDate: "2019-11-06T18:00:00Z",
                    endDate: "2019-11-07T10:00:00Z",
                    type: "historical",
                    recipient: {
                      id: "8e3d055d-2b50-444d-ab89-d4353e831219",
                      type: "user",
                      name: "foo@example.com",
                    },
                    flattenedRecipients: [
                      {
                        id: "8e3d055d-2b50-444d-ab89-d4353e831219",
                        type: "user",
                        name: "foo@example.com",
                      },
                    ],
                  },
                ],
              },
            ],
          },
        },
      }
    end
    let(:datetime) { CGI.escape(Date.today.to_datetime.to_s) }
    let(:timeline) { rotation.timeline }

    it "makes the correct API call" do
      url = "https://api.opsgenie.com/v2/schedules/123/timeline?date=#{datetime}"

      stub = stub_get_request(url, body)

      expect(timeline["id"]).to eq("12339")
      expect(stub).to have_been_requested
    end
  end
end

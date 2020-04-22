require "spec_helper"

RSpec.describe Opsgenie::Schedule do
  let(:rotations) do
    [
      {
        id: "6fce1fd0-578a-431a-8c18-ae7db8b48bb5",
        name: "Rota",
        startDate: "2019-11-27T10:30:00Z",
        type: "weekly",
        length: 1,
        participants: [
          {
            type: "user",
            id: "055dad59-af7f-42a3-8591-9ac04863e546",
            username: "foo@example.com",
          },
        ],
      },
    ]
  end

  describe "#all" do
    let(:all) { described_class.all }
    let(:url) { "https://api.opsgenie.com/v2/schedules?expand=rotation" }
    let(:body) do
      {
        data: [
          {
            id: "b8e97704-0e9d-41b5-b27c-9d9027c83943",
            name: "ooh_second_line",
            rotations: rotations,
          },
        ],
      }
    end

    it "returns a list of schedules" do
      stub = stub_get_request(url, body)

      expect(all.count).to eq(1)
      expect(all.first).to be_a(Opsgenie::Schedule)
      expect(all.first.rotations.count).to eq(1)
      expect(all.first.rotations.first).to be_a(Opsgenie::Rotation)
      expect(stub).to have_been_requested
    end
  end

  describe "#find" do
    let(:id) { "b8e97704-0e9d-41b5-b27c-9d9027c83943" }
    let(:schedule) { described_class.find(id) }

    it "returns a schedule" do
      stub = stub_schedule_show_request

      expect(schedule).to be_a(Opsgenie::Schedule)
      expect(schedule.id).to eq(id)
      expect(schedule.name).to eq("ooh_second_line")
      expect(stub).to have_been_requested
    end

    context "when schedule does not exist" do
      let(:id) { "b1d1b076-70b3-43a6-ac3b-ac386fdca79c" }
      let(:body) do
        {
          code: 40301,
          message: "Api key is not authorized to access the schedule",
          took: 0.008,
          requestId: "e49a7896-b78b-4775-b100-a1639241b195",
        }
      end
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}?identifierType=id" }

      it "returns nil" do
        stub = stub_get_request(url, body)

        expect(schedule).to eq(nil)
        expect(stub).to have_been_requested
      end
    end
  end

  describe "#find_by_name" do
    let(:name) { "ooh_second_line" }
    let(:schedule) { described_class.find_by_name(name) }
    let(:url) { "https://api.opsgenie.com/v2/schedules/#{name}?identifierType=name" }

    it "returns a schedule" do
      stub = stub_schedule_show_request(url)

      expect(schedule).to be_a(Opsgenie::Schedule)
      expect(schedule.id).to eq("b8e97704-0e9d-41b5-b27c-9d9027c83943")
      expect(schedule.name).to eq(name)
      expect(stub).to have_been_requested
    end

    context "when schedule does not exist" do
      let(:name) { "some_schedule" }
      let(:body) do
        {
          code: 40301,
          message: "Api key is not authorized to access the schedule",
          took: 0.008,
          requestId: "e49a7896-b78b-4775-b100-a1639241b195",
        }
      end

      it "returns nil" do
        stub = stub_get_request(url, body)

        expect(schedule).to eq(nil)
        expect(stub).to have_been_requested
      end
    end
  end

  describe "#find_by_id" do
    let(:id) { "b8e97704-0e9d-41b5-b27c-9d9027c83943" }
    let(:schedule) { described_class.find_by_id(id) }
    let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}?identifierType=id" }

    it "returns a schedule" do
      stub = stub_schedule_show_request(url)

      expect(schedule).to be_a(Opsgenie::Schedule)
      expect(schedule.id).to eq(id)
      expect(schedule.name).to eq("ooh_second_line")
      expect(stub).to have_been_requested
    end

    context "when schedule does not exist" do
      let(:id) { "sdsfdsfsdfsf" }
      let(:body) do
        {
          code: 40301,
          message: "Api key is not authorized to access the schedule",
          took: 0.008,
          requestId: "e49a7896-b78b-4775-b100-a1639241b195",
        }
      end

      it "returns nil" do
        stub = stub_get_request(url, body)

        expect(schedule).to eq(nil)
        expect(stub).to have_been_requested
      end
    end
  end

  describe "on_calls" do
    let(:id) { "e71d500f-896a-4b28-8b08-3bfe56e1ed76" }
    let(:schedule) { described_class.new("id" => id, "name" => "first_line", "rotations" => []) }
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
            {
              id: "acd9af98-e3c0-4588-8276-1c545911e44f",
              name: "jane.doe@opsgenie.com",
              type: "user",
            },
          ],
        },
        took: 0.098,
        requestId: "0c607829-68d2-4aee-8e2a-10acd972f067",
      }
    end

    context "with no day specified" do
      let(:on_calls) { schedule.on_calls }
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/on-calls" }

      it "returns the expected users" do
        stub_user_list_request
        stub = stub_get_request(url, body)

        expect(on_calls.count).to eq(2)
        expect(on_calls[0]).to be_a(Opsgenie::User)
        expect(on_calls[0].username).to eq("john.doe@opsgenie.com")
        expect(on_calls[1]).to be_a(Opsgenie::User)
        expect(on_calls[1].username).to eq("jane.doe@opsgenie.com")

        expect(stub).to have_been_requested
      end
    end

    context "with a specified day" do
      let(:date) { DateTime.parse("2019-10-25") }
      let(:on_calls) { schedule.on_calls(date) }
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/on-calls?date=2019-10-25T00:00:00%2B00:00" }

      it "returns the expected users" do
        stub_user_list_request
        stub = stub_get_request(url, body)

        expect(on_calls.count).to eq(2)
        expect(on_calls[0]).to be_a(Opsgenie::User)
        expect(on_calls[0].username).to eq("john.doe@opsgenie.com")
        expect(on_calls[1]).to be_a(Opsgenie::User)
        expect(on_calls[1].username).to eq("jane.doe@opsgenie.com")

        expect(stub).to have_been_requested
      end
    end
  end

  describe "timeline" do
    let(:id) { "e71d500f-896a-4b28-8b08-3bfe56e1ed76" }
    let(:schedule) { described_class.new("id" => id, "name" => "first_line", "rotations" => []) }
    let(:body) do
      {
        data: {
          finalTimeline: {
            rotations: [
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
            ],
          },
        },
      }
    end
    let(:datetime) { CGI.escape(Date.today.to_datetime.to_s) }
    let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/timeline?date=#{datetime}" }

    let!(:stub) { stub_get_request(url, body) }

    before do
      stub_user_list_request
    end

    context "with the default arguments" do
      let(:timeline) { schedule.timeline }

      it "returns data for the timeline" do
        expect(timeline.count).to eq(1)
        expect(timeline.first.id).to eq("538465d7-67d0-4d3d-80e0-e2a07a2b5649")
        expect(stub).to have_been_requested
      end

      context "when there are no periods specified" do
        let(:body) do
          {
            data: {
              finalTimeline: {
                rotations: [
                  id: "538465d7-67d0-4d3d-80e0-e2a07a2b5649",
                  name: "OOH",
                  order: 5.0,
                ],
              },
            },
          }
        end

        it "returns an empty array for the period" do
          expect(schedule.timeline[0].periods).to eq([])
        end
      end
    end

    context "with date specified" do
      let(:date) { Date.parse("2019-01-01") }
      let(:datetime) { CGI.escape(date.to_datetime.to_s) }
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/timeline?date=#{datetime}" }
      let(:timeline) { schedule.timeline(date: date) }

      it "adds the expected date to the url" do
        expect(timeline.count).to eq(1)
        expect(stub).to have_been_requested
      end
    end

    context "with interval data specified" do
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/timeline?date=#{datetime}&interval=1&intervalUnit=months" }
      let(:timeline) { schedule.timeline(interval_unit: :months, interval: 1) }

      it "adds the expected interval data to the url" do
        expect(timeline.count).to eq(1)
        expect(stub).to have_been_requested
      end
    end

    context "when interval unit is invalid" do
      let(:timeline) { schedule.timeline(interval_unit: :eons, interval: 1) }

      it "raises an error" do
        expect { timeline }.to raise_error(ArgumentError)
      end
    end
  end
end

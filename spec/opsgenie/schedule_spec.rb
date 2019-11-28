require "spec_helper"

RSpec.describe Opsgenie::Schedule do
  let!(:stub) do
    stub_request(:get, url)
      .to_return(
        body: body.to_json,
        headers: {"Content-Type" => "application/json"}
      )
  end

  describe "#all" do
    let(:all) { described_class.all }
    let(:url) { "https://api.opsgenie.com/v2/schedules" }
    let(:body) do
      {
        data: [
          {
            id: "b8e97704-0e9d-41b5-b27c-9d9027c83943",
            name: "ooh_second_line",
          },
        ],
      }
    end

    it "returns a list of schedules" do
      expect(all.count).to eq(1)
      expect(all.first).to be_a(Opsgenie::Schedule)
      expect(stub).to have_been_requested
    end
  end

  describe "#find" do
    let(:id) { "b8e97704-0e9d-41b5-b27c-9d9027c83943" }
    let(:schedule) { described_class.find(id) }
    let(:body) do
      {
        data: {
          id: "b8e97704-0e9d-41b5-b27c-9d9027c83943",
          name: "ooh_second_line",
          description: "",
          timezone: "Europe/London",
          enabled: true,
        },
      }
    end
    let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}?identifierType=id" }

    it "returns a schedule" do
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

      it "returns nil" do
        expect(schedule).to eq(nil)
        expect(stub).to have_been_requested
      end
    end
  end

  describe "#find_by_name" do
    let(:name) { "first_line" }
    let(:schedule) { described_class.find_by_name(name) }
    let(:body) do
      {
        data: {
          id: "b8e97704-0e9d-41b5-b27c-9d9027c83943",
          name: "first_line",
          description: "",
          timezone: "Europe/London",
          enabled: true,
        },
      }
    end
    let(:url) { "https://api.opsgenie.com/v2/schedules/#{name}?identifierType=name" }

    it "returns a schedule" do
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
        expect(schedule).to eq(nil)
        expect(stub).to have_been_requested
      end
    end
  end

  describe "on_calls" do
    let(:id) { "e71d500f-896a-4b28-8b08-3bfe56e1ed76" }
    let(:schedule) { described_class.new("id" => id, "name" => "first_line") }
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

    context "with no day specified" do
      let(:on_calls) { schedule.on_calls }
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/on-calls" }

      it "returns the expected users" do
        expect(on_calls).to eq([
          "foo@example.com",
          "bar@example.com",
          "baz@example.com",
        ])
        expect(stub).to have_been_requested
      end
    end

    context "with a specified day" do
      let(:date) { DateTime.parse("2019-10-25") }
      let(:on_calls) { schedule.on_calls(date) }
      let(:url) { "https://api.opsgenie.com/v2/schedules/#{id}/on-calls?date=2019-10-25T00:00:00%2B00:00" }

      it "returns the expected users" do
        expect(on_calls).to eq([
          "foo@example.com",
          "bar@example.com",
          "baz@example.com",
        ])
        expect(stub).to have_been_requested
      end
    end
  end
end

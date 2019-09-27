require "spec_helper"

RSpec.describe Opsgenie::Schedule, :vcr do
  describe "#all" do
    let(:all) { described_class.all }

    it "returns a list of schedules" do
      expect(all.count).to eq(2)
      expect(all.first).to be_a(Opsgenie::Schedule)
    end
  end

  describe "#find" do
    let(:id) { "b8e97704-0e9d-41b5-b27c-9d9027c83943" }
    let(:schedule) { described_class.find(id) }

    it "returns a schedule" do
      expect(schedule).to be_a(Opsgenie::Schedule)
      expect(schedule.id).to eq(id)
      expect(schedule.name).to eq("ooh_second_line")
    end
  end

  describe "on_calls" do
    let(:id) { "e71d500f-896a-4b28-8b08-3bfe56e1ed76" }
    let(:schedule) { described_class.find(id) }

    context "with no day specified" do
      let(:on_calls) { schedule.on_calls }

      it "returns the expected users" do
        Timecop.travel("2019-10-15") do
          expect(on_calls).to eq([
            "systems@dxw.com",
            "chris@dxw.com",
            "robbie.paul@dxw.com",
          ])
        end
      end
    end

    context "with a specified day" do
      let(:date) { Date.parse("2019-10-25") }
      let(:on_calls) { schedule.on_calls(date) }

      it "returns the expected users" do
        Timecop.travel("2019-10-15") do
          expect(on_calls).to eq([
            "systems@dxw.com",
            "chris@dxw.com",
            "laura@dxw.com",
          ])
        end
      end
    end
  end
end

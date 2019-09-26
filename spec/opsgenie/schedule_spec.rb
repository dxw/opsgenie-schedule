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
end

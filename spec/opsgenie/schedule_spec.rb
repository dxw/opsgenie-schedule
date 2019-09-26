require "spec_helper"

RSpec.describe Opsgenie::Schedule, :vcr do
  describe "#all" do
    let(:all) { described_class.all }

    it "returns a list of schedules" do
      expect(all.count).to eq(2)
      expect(all.first).to be_a(Opsgenie::Schedule)
    end
  end
end

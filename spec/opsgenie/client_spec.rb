require "spec_helper"

RSpec.describe Opsgenie::Client do
  it "raises an error if the API key is not set" do
    expect(Opsgenie::Config).to receive(:opsgenie_api_key) { nil }

    expect { described_class.get("/") }.to raise_error(Opsgenie::ConfigurationError)
  end
end

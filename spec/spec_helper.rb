$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "opsgenie"
require "pry"
require "dotenv"

Dotenv.load

require "webmock/rspec"
require "support/webmock_helpers"

RSpec.configure do |config|
  config.order = :random
  config.include WebMockHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:all) do
    Opsgenie.configure(api_key: ENV["OPSGENIE_API_KEY"])
  end
end

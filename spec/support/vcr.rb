require "vcr"

filter_vars = if File.file?(".env")
  dotenv = File.open(".env")
  Dotenv::Environment.new(dotenv, true)
else
  ENV
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.default_cassette_options = {record: :new_episodes}
  c.configure_rspec_metadata!
  filter_vars.each do |key, value|
    c.filter_sensitive_data("<#{key}>") { value }
  end
end

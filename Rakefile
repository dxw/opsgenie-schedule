$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "opsgenie"

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec]

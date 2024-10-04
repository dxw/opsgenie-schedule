lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "opsgenie-schedule"
  spec.version = "0.1.6"
  spec.authors = ["Stuart Harrison"]
  spec.email = ["stuart@dxw.com"]

  spec.summary = "A RubyGem that fetches Opsgenie schedules"
  spec.homepage = "https://github.com/dxw/opsgenie-schedule"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.14.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.40"
  spec.add_development_dependency "webmock", "~> 3.5"
  spec.add_development_dependency "dotenv", "~> 2.7"

  spec.add_dependency "httparty", "~> 0.17"
end

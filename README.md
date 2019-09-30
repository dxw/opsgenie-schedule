[![Build Status](https://github.com/dxw/opsgenie-schedule/workflows/Build/badge.svg)](https://github.com/dxw/opsgenie-schedule/actions)

# Opsgenie Schedule

A simple gem that fetches the scheduled people working on a given date for any Opsgenie schedule.

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'opsgenie-schedule'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install opsgenie-schedule
```

## Usage

Require and initialize the gem like so:

```ruby
require 'opsgenie-schedule'

Opsgenie::Configure(api_key: "YOUR_OPSGENIE_API_KEY")
```

And fetch a schedule by its name:

```ruby
schedule = Opsgenie::Schedule.find_by_name("schedule_name")
```

Or its ID

```ruby
schedule = Opsgenie::Schedule.find_by_id("some_uuid")
```

You can then fetch the people scheduled for today like so:

```ruby
schedule.on_calls
#=> ["someone@example.com", "someone-else@example.com"]
```

Or a given date like so:

```ruby
date = Date.parse("2019-01-01")
schedule.on_calls(date)
#=> ["someone@example.com", "someone-else@example.com"]
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dxw/opsgenie-schedule. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MarketplaceOpportunityScraper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dxw/opsgenie-schedule/blob/master/CODE_OF_CONDUCT.md).


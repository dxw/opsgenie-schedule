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
require 'opsgenie'

Opsgenie.configure(api_key: "YOUR_OPSGENIE_API_KEY")
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
#=> [
#     <Opsgenie::User @full_name="Someone", @id=1234, @username="someone@example.com">,
#     <Opsgenie::User @full_name="Someone Else", @id=1236, @username="somesomeone-elseone@example.com">
#]
```

Or a given date time like so:

```ruby
date = DateTime.parse("2019-01-01T10:00:00")
schedule.on_calls(date)
#=> [
#     <Opsgenie::User @full_name="Someone", @id=1234, @username="someone@example.com">,
#     <Opsgenie::User @full_name="Someone Else", @id=1236, @username="somesomeone-elseone@example.com">
#]
```

You can also fetch a timeline for a schedule:

```ruby
schedule.timeline
```

Or a specific rotation:

```ruby
schedule.rotation[0].timeline
```

You can also specify where you want a timeline to start from:

```ruby
schedule.timeline(date: Date.parse("2019-01-01"))
# => [#<Opsgenie::TimelineRotation:0x00007f9b2f974cb8
#   @id="69e7d46d-538e-4fca-95d0-5c316a54424e",
#   @name="On Call Phone",
#   @periods=
#    [#<Opsgenie::TimelinePeriod:0x00007f9b2f974c40
#      @end_date=#<DateTime: 2019-12-05T11:55:29+00:00 ((2458823j,42929s,816000000n),+0s,2299161j)>,
#      @start_date=#<DateTime: 2019-12-02T00:00:00+00:00 ((2458820j,0s,0n),+0s,2299161j)>,
#      @user=
#       #<Opsgenie::User:0x00007f9b2f329520
#        @full_name="On Call Phone",
#        @id="19e39115-07d5-4924-8295-332a66dd1569",
#        @username="systems@dxw.com">>,
#     ...]
#    ],
#    ...
#   ]
#  >
```

As well as the interval you want to see a timeline for:

```ruby
# `interval_unit` can be one of `:days`, `:weeks` or `:months`
schedule.timeline(interval: 1, interval_unit: :months)
#=> [...]
```

These options also work for a rotation's timeline too:

```ruby
schedule.rotation[0].timeline(
  date: Date.parse("2019-01-01"),
  interval: 1,
  interval_unit: :months
)
#=> <Opsgenie::TimelineRotation:0x00007f9b2f974cb8>
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


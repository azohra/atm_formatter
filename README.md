# Rspec Formatter For Test Managemt For JIRA 
[![Gem Version](https://badge.fury.io/rb/tmj_formatter.svg)](https://badge.fury.io/rb/tmj_formatter)
[![Build Status](https://travis-ci.org/automation-wizards/tmj_formatter.svg?branch=master)](https://travis-ci.org/automation-wizards/tmj_formatter)
[![Coverage Status](https://coveralls.io/repos/github/automation-wizards/tmj_formatter/badge.svg?branch=master)](https://coveralls.io/github/automation-wizards/tmj_formatter?branch=master)
[![Inline docs](http://inch-ci.org/github/automation-wizards/tmj_formatter.svg?branch=master)](http://inch-ci.org/github/automation-wizards/tmj_formatter)
[![Dependency Status](https://gemnasium.com/badges/github.com/automation-wizards/tmj_formatter.svg)](https://gemnasium.com/github.com/automation-wizards/tmj_formatter)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tmj_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tmj_formatter

## Usage

#### Configuration

Configure `tmj_ruby` (instructions can be found [here](https://github.com/automation-wizards/tmj_ruby))

Add result/output formatter, options and adapter in spec_helper
```ruby
RSpec.configure do |config|
  config.include TMJFormatter::Adaptor
  config.formatter = 'TMJResultFormatter'
  config.formatter = 'TMJOutputFormatter'
  
  config.tmj_result_formatter_options = { run_only_found_tests: true, post_results: true }
end
```
By default all of the options are set to false.
`run_only_found_tests` option will force formatter to only run tests from test run.
`post_results` option enables/disable the ability to post the test results.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tmj_formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


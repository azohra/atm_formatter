# Rspec Formatter For Adaptavist Test Management 
[![Gem Version](https://badge.fury.io/rb/atm_formatter.svg)](https://badge.fury.io/rb/atm_formatter)
[![Build Status](https://travis-ci.org/automation-wizards/atm_formatter.svg?branch=master)](https://travis-ci.org/automation-wizards/atm_formatter)
[![Coverage Status](https://coveralls.io/repos/github/automation-wizards/atm_formatter/badge.svg?branch=master)](https://coveralls.io/github/automation-wizards/atm_formatter?branch=master)
[![Inline docs](http://inch-ci.org/github/automation-wizards/atm_formatter.svg?branch=master)](http://inch-ci.org/github/automation-wizards/atm_formatter)
[![Dependency Status](https://gemnasium.com/badges/github.com/automation-wizards/atm_formatter.svg)](https://gemnasium.com/github.com/automation-wizards/atm_formatter)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'atm_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atm_formatter

## Usage

#### Configuration
For more information refer to the [wiki](https://github.com/automation-wizards/atm_formatter/wiki)

```ruby
ATMFormatter.configure do |c|
  c.base_url    = 'https://localhost'
  c.auth_type   = :basic
  c.project_id  = 'CC'
  c.test_run_id = 'CC-R180'
  c.environment = "".upcase
  c.username    = 'Test'
  c.password    = 'Test'
  c.result_formatter_options      = { run_only_found_tests: false, post_results: false }
  c.create_test_formatter_options = { update_existing_tests: true, 
                                      test_owner: 'Test', 
                                      custom_labels: ['automated'] }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/atm_formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
require 'tmj_formatter'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.include TMJFormatter::Adaptor
  config.formatter = 'TMJResultFormatter'
  config.formatter = 'TMJOutputFormatter'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

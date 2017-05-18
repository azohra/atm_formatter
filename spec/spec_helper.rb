require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
require 'tmj_formatter'
require 'pry'


TMJFormatter.configure do |c|
  c.base_url    = 'https://localhost'
  c.auth_type   = :basic
  c.project_id  = 'CC'
  c.test_run_id = 'CC-R180'
  c.environment = "".upcase
  c.username    = 'Test'
  c.password    = 'Test'
  c.result_formatter_options      = { run_only_found_tests: false, post_results: true }
  c.create_test_formatter_options = { update_existing_tests: true, test_owner: 'Test', custom_labels: ['automated'] }
end

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


require 'tmj_formatter'
require_relative 'lib/tmj_formatter/example'

class RspecConfig
  RSpec.configure do |c|
    c.color = true
    c.formatter = 'TMJCreateTestFormatter'
    c.tmj_create_test_formatter_options = { update_existing_tests: true, test_owner: 'test', custom_labels: ['automated'] }
  end
end
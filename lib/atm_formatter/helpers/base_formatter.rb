require 'rspec/core/formatters/base_formatter'
module ATMFormatter
class BaseFormatter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_OPTIONS = { update_existing_tests: false, test_owner: nil, custom_labels: nil}.freeze

  NOTIFICATIONS = %i[start, example_started].freeze

  def start(_notification)
    @options = DEFAULT_OPTIONS.merge(ATMFormatter.config.create_test_formatter_options)
    @client = ATM::Client.new(ATMFormatter.config.to_hash)
  end

  private

  def process_example(example)
    {
        "projectKey":   configure_project_key,
        "name":         example.metadata[:full_description],
        "objective":    example.metadata[:objective],
        "precondition": example.metadata[:precondition],
        "folder":       example.metadata[:folder],
        "status":       example.metadata[:status],
        "priority":     example.metadata[:priority],
        "owner":        @options[:test_owner],
        "labels":       @options[:custom_labels],
        "testScript":   process_steps(example.metadata[:steps])
    }.delete_if { |k, v| v.nil? || v.empty?}
  end


  def configure_project_key
    self.class.to_s == 'ATMUpdateTestFormatter' ? nil : ATMFormatter.config.project_id
  end

  def process_steps(example)
    return unless example
    arr = []
    example.each { |s| arr << {"description": s[:step_name]} }
    {
        "type": "STEP_BY_STEP",
        "steps": arr
    }
  end
end
end
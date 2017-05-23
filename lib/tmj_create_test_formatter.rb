require 'rspec/core/formatters/base_formatter'

class TMJCreateTestFormatter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_CREATE_TEST_FORMATTER_OPTIONS = { update_existing_tests: false, test_owner: nil, custom_labels: nil}.freeze

  RSpec::Core::Formatters.register self, :start, :example_started

  def start(_notification)
    @options = DEFAULT_CREATE_TEST_FORMATTER_OPTIONS.merge(TMJFormatter.config.create_test_formatter_options)
    @client = TMJ::Client.new(TMJFormatter.config.to_hash)
  end

  def example_started(notification)
    if (notification.example.metadata.has_key?(:test_id) && !notification.example.metadata[:test_id].strip.empty?) || !notification.example.metadata.has_key?(:test_id)
      return
    end

    response = @client.TestCase.create(process_example(notification.example))
    if response.code != 201
      puts TMJ::TestCaseError.new(response).message
      exit
    end

    update_local_test(notification.example, response['key'])
  end

  private

  def update_local_test(example, test_key)
    lines = File.readlines(example.metadata[:file_path])
    lines[line_number(example)].gsub!("test_id: ''", "test_id: '#{test_key}'")
    File.open(example.metadata[:file_path], 'w') { |f| f.write(lines.join) }
  end

  def line_number(example)
    example.metadata[:line_number]-1
  end

  def process_example(example)
  {
        "projectKey": "#{TMJFormatter.config.project_id}",
        "name": "#{example.metadata[:description]}",
        "precondition": "#{example.metadata[:precondition]}",
        "owner": "#{@options[:test_owner]}",
        "labels": @options[:custom_labels],
        "testScript": {
            "type": "STEP_BY_STEP",
            "steps": process_steps(example.metadata[:steps])
        }
    }.delete_if { |k, v| v.nil? || v.empty?}
  end

  def process_steps(examole)
    arr = []
    examole.each { |s| arr << {"description": s[:step_name]} }
    arr
  end

end

# TODO: be able to update test case.
require_relative 'atm_formatter/helpers/base_formatter'

class ATMCreateTestFormatter < ATMFormatter::BaseFormatter
  RSpec::Core::Formatters.register self, *NOTIFICATIONS

  def example_started(notification)
    if (notification.example.metadata.key?(:test_id) && !notification.example.metadata[:test_id].strip.empty?) || !notification.example.metadata.key?(:test_id)
      return
    end

    response = @client.TestCase.create(process_example(notification.example))
    if response.code != 201
      puts ATM::TestCaseError.new(response).message
      exit
    end

    update_local_test(notification.example, response['key'])
  end

  private

  def update_local_test(example, test_key)
    lines = File.readlines(example.metadata[:file_path])
    lines[line_number(example)].gsub!(/test_id:(\s+)?('|")(\s+)?('|")/, "test_id: '#{test_key}'")
    File.open(example.metadata[:file_path], 'w') { |f| f.write(lines.join) }
  end

  def line_number(example)
    example.metadata[:line_number] - 1
  end
end

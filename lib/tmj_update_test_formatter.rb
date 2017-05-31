require_relative 'tmj_formatter/helpers/base_formatter'

class TMJUpdateTestFormatter < TMJFormatter::BaseFormatter
  RSpec::Core::Formatters.register self, *NOTIFICATIONS

  def example_started(notification)
    if (notification.example.metadata.has_key?(:test_id) && notification.example.metadata[:test_id].strip.empty?) || !notification.example.metadata.has_key?(:test_id)
      return
    end

    response = @client.TestCase.update(notification.example.metadata[:test_id], process_example(notification.example))
    if response.code != 200
      puts TMJ::TestCaseError.new(response).message
      exit
    end
  end
end

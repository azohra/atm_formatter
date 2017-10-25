require_relative 'atm_formatter/helpers/base_formatter'

class ATMUpdateTestFormatter < ATMFormatter::BaseFormatter
  RSpec::Core::Formatters.register self, *NOTIFICATIONS

  def example_started(notification)
    if (notification.example.metadata.key?(:test_id) && notification.example.metadata[:test_id].strip.empty?) || !notification.example.metadata.key?(:test_id)
      return
    end

    response = @client.TestCase.update(notification.example.metadata[:test_id], process_example(notification.example))
    if response.code != 200
      puts ATM::TestCaseError.new(response).message
      exit
    end
  end
end

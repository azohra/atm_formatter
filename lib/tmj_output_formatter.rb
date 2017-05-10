require 'rspec/core/formatters/base_text_formatter'

class TMJOutputFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_group_started, :example_group_finished,
                                   :example_passed, :example_pending, :example_failed, :example_started


  def example_started(notification)
  end

  def example_group_started(notification)
  end

  def example_group_finished(notification)
  end

  def example_passed(notification)

  end

  def example_failed(notification)
  end
end

class TMJOutputFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_failed, :example_pending

  def example_started(notification)
  end

  def example_passed(notification)
  end

  def example_failed(notification)
  end

  def example_pending(notification)
  end
end

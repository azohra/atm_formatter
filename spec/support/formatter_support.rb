module FormatterSupport
  def send_notification(type, notification)
    reporter.notify type, notification
  end

  def reporter
    @reporter ||= setup_reporter
  end

  def setup_reporter(*streams)
    streams << config.output_stream if streams.empty?
    config.formatter_loader.add described_class, *streams
    @formatter = config.formatters.first
    @reporter = config.reporter
  end

  def setup_profiler
    config.profile_examples = true
    reporter.setup_profiler
  end

  def formatter_output
    @formatter_output ||= StringIO.new
  end

  def config
    @configuration ||=
      begin
        config = RSpec::Core::Configuration.new
        config.output_stream = formatter_output
        config
      end
  end

  def configure
    yield config
  end

  def formatter
    @formatter ||=
      begin
        setup_reporter
        @formatter
      end
  end

  def new_example(metadata = {})
    metadata = metadata.dup
    result = RSpec::Core::Example::ExecutionResult.new
    result.started_at = ::Time.now
    result.record_finished(metadata.delete(:status) { :passed }, ::Time.now)
    result.exception = Exception.new if result.status == :failed

    instance_double(RSpec::Core::Example,
                    description: 'Example',
                    full_description: 'Example',
                    example_group: group,
                    execution_result: result,
                    location: '',
                    location_rerun_argument: '',
                    metadata: {
                      shared_group_inclusion_backtrace: []
                    }.merge(metadata))
  end

  def examples(n)
    Array.new(n) { new_example }
  end

  def group
    group = class_double 'RSpec::Core::ExampleGroup', description: 'Group'
    allow(group).to receive(:parent_groups) { [group] }
    group
  end

  def example_started(specific_example = new_example)
    ::RSpec::Core::Notifications::ExampleNotification.for specific_example
  end
  alias_method :example_passed, :example_started
  alias_method :example_pending, :example_started
  alias_method :example_failed, :example_started

  def start_notification(count)
    ::RSpec::Core::Notifications::StartNotification.new count
  end

  def stop_notification
    ::RSpec::Core::Notifications::ExamplesNotification.new reporter
  end

  def example_notification(specific_example = new_example)
    ::RSpec::Core::Notifications::ExampleNotification.for specific_example
  end

  def group_notification(group_to_notify = group)
    ::RSpec::Core::Notifications::GroupNotification.new group_to_notify
  end

  def message_notification(message)
    ::RSpec::Core::Notifications::MessageNotification.new message
  end

  def null_notification
    ::RSpec::Core::Notifications::NullNotification
  end

  def seed_notification(seed, used = true)
    ::RSpec::Core::Notifications::SeedNotification.new seed, used
  end

  def failed_examples_notification
    ::RSpec::Core::Notifications::ExamplesNotification.new reporter
  end

  def summary_notification(duration, examples, failed, pending, time, errors = 0)
    ::RSpec::Core::Notifications::SummaryNotification.new duration, examples, failed, pending, time, errors
  end

  def profile_notification(duration, examples, number)
    ::RSpec::Core::Notifications::ProfileNotification.new duration, examples, number, reporter.instance_variable_get('@profiler').example_groups
  end
end

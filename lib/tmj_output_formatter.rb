require 'rspec/core/formatters/base_text_formatter'

class TMJOutputFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_group_started, :example_group_finished,
                                   :example_passed, :example_pending, :example_failed, :example_started

  def initialize(output)
    super
    @group_level = 0
  end

  def example_started(notification)
    notification.example.metadata[:step_index] = 0
  end

  def example_group_started(notification)
    output.puts if @group_level.zero?
    output.puts "#{current_indentation}#{notification.group.description.strip}"

    @group_level += 1
  end

  def example_group_finished(_notification)
    @group_level -= 1
  end

  def example_passed(passed)
    passed_output(passed.example)
  end

  def example_pending(pending)
    pending_output(pending.example,
                   pending.example.execution_result.pending_message)
  end

  def example_failed(failure)
    failure_output(failure.example)
  end

  private

  def passed_output(example)
    output.puts RSpec::Core::Formatters::ConsoleCodes.wrap("#{current_indentation}#{example.description.strip}", :success)
    format_output(example) if example.metadata.key?(:steps)
  end

  def pending_output(example, message)
    output.puts RSpec::Core::Formatters::ConsoleCodes.wrap("#{current_indentation}#{example.description.strip} " \
                            "(PENDING: #{message})",
                                                           :pending)
  end

  def failure_output(example)
    output.puts RSpec::Core::Formatters::ConsoleCodes.wrap("#{current_indentation}#{example.description.strip} " \
                            "(FAILED - #{next_failure_index})",
                                                           :failure)
    format_output(example) unless example.metadata[:steps].nil?
  end

  def next_failure_index
    @next_failure_index ||= 0
    @next_failure_index += 1
  end

  def current_indentation
    '  ' * @group_level
  end

  def format_output(example)
    example.metadata[:steps].each do |step|
      output.puts RSpec::Core::Formatters::ConsoleCodes.wrap("#{'  ' * (@group_level + 1)}step #{step[:index] + 1}: #{step[:step_name]}", current_color(step[:status]))
    end
  end

  def current_color(status)
    case status
      when 'Pass' then :success
      when 'Fail' then :failure
      else :pending
    end
  end
end

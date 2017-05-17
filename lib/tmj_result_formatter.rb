require 'rspec/core/formatters/base_formatter'

RSpec.configuration.add_setting :tmj_result_formatter_options, default: {}

class TMJResultFormatter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_RESULT_FORMATTER_OPTIONS = { run_only_found_tests: false, post_results: false }.freeze

  RSpec::Core::Formatters.register self, :start, :example_started, :example_passed, :example_failed

  def start(_notification)
    @options = DEFAULT_RESULT_FORMATTER_OPTIONS.merge(RSpec.configuration.tmj_result_formatter_options)
    if @options[:run_only_found_tests]
      @client = TMJ::Client.new
      test_run_data = @client.TestRun.find(TMJ.config.test_run_id)
      @test_cases = @client.TestCase.retrive_based_on_username(test_run_data, TMJ.config.username.downcase)
    end
  end

  def example_started(notification)
    if @options[:run_only_found_tests] && !@test_cases.include?(test_id(notification.example))
      notification.example.metadata[:skip] = true
    end
    notification.example.metadata[:step_index] = 0
  end

  def example_passed(notification)
    post_result(notification.example)
  end

  def example_failed(notification)
    post_result(notification.example)
  end

  private

  def post_result(example)
    return unless @options[:post_results]
    begin
      if TMJ.config.test_run_id
        response = @client.TestRun.create_new_test_run_result(test_id(example), with_steps(example))
        raise TMJ::TestRunError, response unless response.code == 201
      else
        response = @client.TestCase.create_new_test_result(example.metadata)
        raise TMJ::TestCaseError, response unless response.code == 201
      end
    rescue => e
      puts e, e.message
      exit
    end
  end

  def with_steps(example) # TODO: Make this better
    {
      test_case: test_id(example),
      status: status(example.metadata[:execution_result]),
      environment: fetch_environment(example),
      comment: comment(example.metadata),
      execution_time: run_time(example.metadata[:execution_result]),
      script_results: steps(example.metadata)
    }.delete_if { |k, v| v.nil? }
  end

  def without_steps(example) # TODO: Make this better
    {
      test_case: test_id(example),
      status: status(example.metadata[:execution_result]),
      comment: comment(example.metadata),
      execution_time: run_time(example.metadata[:execution_result])
    }
  end

  def fetch_environment(example)
    if example.metadata[:environment] && !example.metadata[:environment].empty?
      example.metadata[:environment]
    elsif TMJ.config.environment && !TMJ.config.environment.empty?
      TMJ.config.environment
    end
  end

  def test_id(example)
    example.metadata[:test_id]
  end

  def status(scenario)
    status_code(scenario.status)
  end

  def comment(scenario) # TODO: need to be changed
    if scenario[:kanoah_evidence].nil?
      "#{scenario[:execution_result].exception.inspect}<br />"
    else
      scenario[:kanoah_evidence][:title] + "\n" + scenario[:kanoah_evidence][:path]
    end
  end

  def run_time(scenario)
    scenario.run_time.to_i * 1000
  end

  def steps(scenario) # TODO: Make this better
    arr = []
    scenario[:steps].each { |s| arr << s.reject { |k, _v| k == :step_name } }
    arr
  end

  def status_code(status)
    case status
    when :failed, :passed then
      status.to_s.gsub('ed', '').capitalize
    when :pending then
      'Blocked'
    end
  end
end

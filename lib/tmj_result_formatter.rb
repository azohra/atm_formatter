require 'rspec/core/formatters/base_formatter'

class TMJResultFormatter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_RESULT_FORMATTER_OPTIONS = { run_only_found_tests: false, post_results: false }.freeze

  RSpec::Core::Formatters.register self, :start, :example_started, :dump_summary, :close

  def start(_notification)
    @options = DEFAULT_RESULT_FORMATTER_OPTIONS.merge(TMJFormatter.config.result_formatter_options)
    @client = TMJ::Client.new(TMJFormatter.config.to_hash)
    if @options[:run_only_found_tests]
      test_run_data = @client.TestRun.find(TMJFormatter.config.test_run_id)
      if test_run_data.code != 200
        puts TMJ::TestRunError.new(test_run_data).message
        exit
      end
      @test_cases = @client.TestCase.retrive_based_on_username(test_run_data, TMJFormatter.config.username.downcase)
    end

    @test_results = {}
    @test_data = []
    Dir.mkdir('test_results') unless Dir.exist?('test_results')
  end

  def dump_summary(notification)
    notification.examples.each do |example|
      file_path = example.metadata[:file_path].match(/[^\/]*_spec/)[0] # "#{}.json"
      @test_results[file_path.to_sym] = { test_cases: [] }
      test_data = @client.TestRun.process_result(process_metadata(example))
      @test_data <<  if TMJFormatter.config.test_run_id
                       test_data.merge!(test_run_id: TMJFormatter.config.test_run_id, test_case: example.metadata[:test_id], file_path: file_path)
                     else
                       test_data.merge!(test_case: example.metadata[:test_case], file_path: file_path)
                     end
    end

    @test_results.each do |k, _v|
      @test_data.each do |test_case_data|
        if k.to_s == test_case_data[:file_path]
          test_case_data.delete(:file_path)
          @test_results[k][:test_cases] << test_case_data
        end
      end
    end
  end

  def close(_notification)
    @test_results.each do |key, _value|
      File.open("test_results/#{key}.json", 'w') do |config|
        config.puts(JSON.pretty_generate(@test_results[key]))
      end
    end
  end

  def example_started(notification)
    if @options[:run_only_found_tests] && !@test_cases.include?(test_id(notification.example))
      notification.example.metadata[:skip] = "#{notification.example.metadata[:test_id]} was not found in the #{TMJFormatter.config.test_run_id} test run."
    end

    notification.example.metadata[:step_index] = 0
  end

  private

  def process_metadata(example)
    {
      test_case: test_id(example),
      status: status(example.metadata[:execution_result]),
      environment: fetch_environment(example),
      comment: comment(example.metadata),
      execution_time: run_time(example.metadata[:execution_result]),
      script_results: steps(example.metadata)
    }.delete_if { |_k, v| v.nil? }
  end

  def fetch_environment(example)
    if example.metadata[:environment] && !example.metadata[:environment].empty?
      example.metadata[:environment]
    elsif TMJFormatter.config.environment && !TMJFormatter.config.environment.empty?
      TMJFormatter.config.environment
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
    return unless scenario[:steps]
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

require 'rspec/core/formatters/base_formatter'

class ATMResultFormatter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_RESULT_FORMATTER_OPTIONS = { run_only_found_tests: false, post_results: false }.freeze

  RSpec::Core::Formatters.register self, :start, :example_started, :dump_summary, :close

  def start(_notification)
    @options = DEFAULT_RESULT_FORMATTER_OPTIONS.merge(ATMFormatter.config.result_formatter_options)
    @client = ATM::Client.new(ATMFormatter.config.to_hash)
    if @options[:run_only_found_tests]
      test_run_data = @client.TestRun.find(ATMFormatter.config.test_run_id)
      if test_run_data.code != 200
        puts ATM::TestRunError.new(test_run_data).message
        exit
      end
      @test_cases = @client.TestCase.retrive_based_on_username(test_run_data, ATMFormatter.config.username.downcase)
    end

    @time_stamp = "#{Time.now.to_i.to_s}-#{rand(10**10)}"
    @test_results = {}
    @test_data = []
    Dir.mkdir('test_results') unless Dir.exist?('test_results')
  end

  def dump_summary(notification)
    notification.examples.each do |example|
      file_name = example.metadata[:file_path].match(/[^\/]*_spec/)[0] # "#{}.json"
      file_path = "#{file_name}_#{@time_stamp}"
      @test_results[file_path.to_sym] = { test_cases: [] }
      test_data = @client.TestRun.process_result(process_metadata(example))
      @test_data << if ATMFormatter.config.test_run_id
                      test_data.merge!(test_run_id: ATMFormatter.config.test_run_id,
                                       test_case_id: example.metadata[:test_id],
                                       file_path: file_path)
                    else
                      test_data.merge!(test_case_id: example.metadata[:test_id],
                                       file_path: file_path)
                    end
    end

    @test_results.each do |key, _value|
      @test_data.each do |test_case_data|
        if key.to_s == test_case_data[:file_path]
          test_case_data.delete(:file_path)
          @test_results[key][:test_cases] << test_case_data
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
    if notification.example.metadata[:environment] || ATMFormatter.config.environment
      configure_env(notification.example)
    end

    if @options[:run_only_found_tests] && !@test_cases.include?(test_id(notification.example))
      notification.example.metadata[:skip] = "#{notification.example.metadata[:test_id]} was not found in the #{ATMFormatter.config.test_run_id} test run."
    end

    notification.example.metadata[:step_index] = 0
  end

  private

  def configure_env(example)
    if (!example.metadata[:environment].nil? && !example.metadata[:environment].strip.empty?) &&
          (!ATMFormatter.config.environment.nil? && !ATMFormatter.config.environment.strip.empty?)
      warn("WARNING: Environment is set twice!
      ATMFormatter.config.environment: #{ATMFormatter.config.environment}
      Spec: #{example.metadata[:environment]}
      Will use environment provided by the spec.")
    elsif example.metadata[:environment].nil? || example.metadata[:environment].strip.empty?
      example.metadata[:environment] = ATMFormatter.config.environment
    end
  end

  def process_metadata(example)
    {
      test_case_id: test_id(example),
      status: status(example.metadata[:execution_result]),
      environment: fetch_environment(example),
      comment: comment(example.metadata),
      execution_time: run_time(example.metadata[:execution_result]),
      script_results: steps(example.metadata)
    }.delete_if { |_k, v| v.nil? }
  end

  def fetch_environment(example)
    if example.metadata[:environment] && !example.metadata[:environment].strip.empty?
      example.metadata[:environment]
    elsif ATMFormatter.config.environment && !ATMFormatter.config.environment.strip.empty?
      ATMFormatter.config.environment
    end
  end

  def test_id(example)
    example.metadata[:test_id]
  end

  def status(scenario)
    status_code(scenario.status)
  end

  def comment(scenario)
    comment = []
    return if scenario[:kanoah_evidence].nil? &&
              scenario[:execution_result].exception.inspect == 'nil'
    comment << scenario[:execution_result].exception.inspect

    comment << "#{scenario[:kanoah_evidence][:title]}<br />#{scenario[:kanoah_evidence][:path]}" unless scenario[:kanoah_evidence].nil?
    comment.join('<br />')
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
      'Not Supported'
    end
  end
end

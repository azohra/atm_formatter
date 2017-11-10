require 'rake'
require 'atm_ruby'
require 'ruby-progressbar'

module ATM
  class CreateTestFormatter
    include Rake::DSL if defined? Rake::DSL
    class << self
      def install_tasks
        new.install
      end
    end

    def install
      namespace 'atm' do
        desc 'Create test cases with steps on Adaptavist Test Management'
        task :create_with_steps, [:path] do |_t, options|
          exec("bundle exec rspec #{options[:path] if options[:path]} --format ATMCreateTestFormatter --dry-run -r atm_formatter/example")
        end

        desc 'Create test cases on Adaptavist Test Management'
        task :create, [:path] do |_t, options|
          exec("bundle exec rspec #{options[:path] if options[:path]} --format ATMCreateTestFormatter --dry-run")
        end

        desc 'Update test cases with steps on Adaptavist Test Management'
        task :update_with_steps, [:path] do |_t, options|
          exec("bundle exec rspec #{options[:path] if options[:path]} --format ATMUpdateTestFormatter --dry-run -r atm_formatter/example")
        end

        desc 'Update test cases on Adaptavist Test Management'
        task :update, [:path] do |_t, options|
          exec("bundle exec rspec #{options[:path] if options[:path]} --format ATMUpdateTestFormatter --dry-run")
        end

        desc 'Upload saved test results'
        task :upload, %i[url username password file_path] do |_t, options|
          client = ATM::Client.new(base_url: options[:url], username: options[:username], password: options[:password], auth_type: :basic)
          files = options[:file_path] ? Dir.glob(options[:file_path]) : Dir.glob('test_results/*.json')

          files.each do |json_file|
            puts "working on: #{json_file}..."
            File.open(json_file, 'r') do |_test_case_data|
              file_data = JSON.parse(File.read(json_file))
              progressbar = ProgressBar.create(total: file_data['test_cases'].size, format: 'Progress %c/%C |%B| %a')
              file_data['test_cases'].each do |test_data|
                test_run_id = test_data.delete('test_run_id')

                if test_run_id
                  test_case_id = test_data.delete('test_case_id')
                  client.TestRun.create_new_test_run_result(test_run_id, test_case_id, test_data)
                  progressbar.increment
                else
                  warn("TEST RUN ID for test_case_id: '#{test_case_id}' was not specified.")
                end
              end
            end
          end
        end
      end
    end
  end
end
ATM::CreateTestFormatter.install_tasks

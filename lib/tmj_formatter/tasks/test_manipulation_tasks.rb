require 'rake'
require 'tmj_ruby'
require 'ruby-progressbar'

module TMJ
  class CreateTestFormatter
    include Rake::DSL if defined? Rake::DSL
    class << self
      def install_tasks
        new.install
      end
    end

    def install
      namespace 'tmj' do
        desc 'Create test cases with steps on Test Managment For JIRA'
        task :create_with_steps, [:path] do |_t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJCreateTestFormatter --dry-run -r tmj_formatter/example")
        end

        desc 'Create test cases on Test Managment For JIRA'
        task :create, [:path] do |_t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJCreateTestFormatter --dry-run")
        end

        desc 'Update test cases with steps on Test Managment For JIRA'
        task :update_with_steps, [:path] do |_t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJUpdateTestFormatter --dry-run -r tmj_formatter/example")
        end

        desc 'Update test cases on Test Managment For JIRA'
        task :update, [:path] do |_t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJUpdateTestFormatter --dry-run")
        end

        desc 'Upload saved test results'
        task :upload, %i[url username password file_path] do |_t, args|
          client = TMJ::Client.new(base_url: args[:url], username: args[:username], password: args[:password], auth_type: :basic)
          files = args[:file_path] ? Dir.glob(args[:file_path]) : Dir.glob('test_results/*.json')

          files.each do |my_text_file|
            puts "working on: #{my_text_file}..."
            File.open(my_text_file, 'r') do |_test_case_data|
              file_data = JSON.parse(File.read(my_text_file))
              progressbar = ProgressBar.create(total: file_data['test_cases'].size, format: 'Progress %c/%C |%B| %a')
              file_data['test_cases'].each do |test_case|
                test_run_id = test_case.delete('test_run_id')
                test_case_id = test_case.delete('test_case') if test_run_id

                if test_run_id
                  client.TestRun.create_new_test_run_result(test_run_id, test_case_id, test_case.to_json)
                  progressbar.increment
                else
                  warn('Have to run against test run')
                end
              end
            end
          end
        end
      end
    end
  end
end
TMJ::CreateTestFormatter.install_tasks

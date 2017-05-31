require 'rake'

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
        task :create_with_steps, [:path] do |t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJCreateTestFormatter --dry-run -r tmj_formatter/example")
        end

        desc 'Create test cases on Test Managment For JIRA'
        task :create, [:path] do |t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJCreateTestFormatter --dry-run")
        end

        desc 'Update test cases with steps on Test Managment For JIRA'
        task :update_with_steps, [:path] do |t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJUpdateTestFormatter --dry-run -r tmj_formatter/example")
        end

        desc 'Update test cases on Test Managment For JIRA'
        task :update, [:path] do |t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJUpdateTestFormatter --dry-run")
        end
      end
    end
  end
end
TMJ::CreateTestFormatter.install_tasks

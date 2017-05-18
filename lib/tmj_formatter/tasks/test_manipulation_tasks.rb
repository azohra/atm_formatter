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
        desc 'Create test cases on Test Managment For JIRA'
        task :create, [:path] do |t, args|
          exec("bundle exec rspec #{args[:path] if args[:path]} --format TMJCreateTestFormatter --dry-run -r tmj_formatter/example")
        end

        desc 'Update test cases on Test Managment For JIRA'
        task :update do
          puts 'not done'
        end
      end
    end
  end
end
TMJ::CreateTestFormatter.install_tasks

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require 'pry'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Post test case structure to the test management for jira'
task :create_tests

RSpec::Core::RakeTask.new(:create_tests) do |t|
  t.rspec_opts = ['--dry-run', '-r ./rspec_config']
end

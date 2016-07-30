require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/testtask"

RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new do |t|
  t.libs << "test" << "lib"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end

task :default => :test

desc "run eventemitter benchmark"
task :benchmark do
  require File.expand_path 'benchmark/benchmark', File.dirname(__FILE__)
  Bench.run
end

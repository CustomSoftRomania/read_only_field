require 'bundler'
Bundler.setup

require 'rspec'
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path("../app/concerns", __FILE__)

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => [:spec]

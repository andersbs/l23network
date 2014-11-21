require 'rake'
require 'rspec/core/rake_task'
#require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_parameter_defaults')

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = 'spec/*/*__spec.rb'
  t.rspec_opts = File.read("spec/spec.opts").chomp || ""
end


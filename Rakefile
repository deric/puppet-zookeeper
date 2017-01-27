require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/version'
require 'puppet/vendor/semantic/lib/semantic' unless Puppet.version.to_f < 3.6
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'

# blacksmith does not support ruby 1.8.7 anymore
if ENV['RAKE_ENV'] != 'ci' && RUBY_VERSION.split('.')[0, 3].join.to_i > 187
  # rubocop is not needed on travis (requires ruby >= 2.0)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  require 'puppet_blacksmith/rake_tasks'
end

desc 'Lint metadata.json file'
task :meta do
  sh 'metadata-json-lint metadata.json'
end

exclude_paths = [
  'bundle/**/*',
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*'
]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

desc 'Populate CONTRIBUTORS file'
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

task :librarian_spec_prep do
  sh 'librarian-puppet install --path=spec/fixtures/modules/'
end
task spec_prep: :librarian_spec_prep
task default: [:spec, :lint]

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  # just `spec/acceptance` caused runnin all specs
  t.pattern = 'spec/acceptance/*_spec.rb'
end

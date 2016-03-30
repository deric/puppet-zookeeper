source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 2.7.0','< 5.0']
gem 'puppet', puppetversion
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'rake'
gem 'librarian-puppet', '>= 2.0'
gem 'highline'
gem 'rspec-puppet-facts'
# coverage reports will be in release 2.0
gem 'rspec', '>= 3.0.0'
gem 'rspec-puppet', '>= 2.3.0'
gem 'metadata-json-lint', :require => false

group :development do
  gem 'puppet-blacksmith'
  gem 'beaker'
  gem 'beaker-rspec', :require => false
end

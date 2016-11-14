source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 2.7.0', '< 5.0']
gem 'puppet', puppetversion
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'rake'
gem 'librarian-puppet', '>= 2.0'
gem 'highline'
gem 'simplecov'
gem 'simplecov-console'
gem 'rspec-puppet-facts'
gem 'rspec', '>= 3.0.0'
gem 'rspec-puppet', '>= 2.3.0'
gem 'metadata-json-lint', require: false
if RUBY_VERSION < "2.0.0"
  gem 'json', '< 2.0' # newer versions requires at least ruby 2.0
  gem 'json_pure', '< 2.0.0'
  gem 'fog-google', '< 0.1.1'
  gem 'google-api-client', '< 0.9'
  gem 'public_suffix', '< 2.0.4'
end

group :development do
  if RUBY_VERSION < "2.0.0"
    gem 'rubocop','~> 0.33.0'
  else
    gem 'rubocop'
  end
  gem 'puppet-blacksmith'
  if RUBY_VERSION >= '2.2.5'
    gem 'beaker'
  else
    gem 'beaker', '< 3'
  end
  gem 'beaker-rspec', require: false
end

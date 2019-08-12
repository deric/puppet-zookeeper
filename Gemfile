source 'https://rubygems.org'

group :tests do
  puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 2.7.0', '< 6.0']
  gem 'puppet', puppetversion
  gem 'rake'
  gem 'puppet-lint'
  gem 'puppetlabs_spec_helper'
  gem 'librarian-puppet', '>= 2.0'
  gem 'highline'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'rspec-puppet-facts'
  gem 'rspec', '>= 3.0.0'
  gem 'rspec-puppet', '>= 2.3.0'
  gem 'metadata-json-lint', require: false
end

# xmlrpc used to be bundled with Ruby until 2.4
if RUBY_VERSION >= '2.4.0'
  gem 'xmlrpc'
end

group :development do
  gem 'rubocop', '>= 0.49.0'
  gem 'puppet-blacksmith', git: 'https://github.com/deric/puppet-blacksmith', branch: 'tag-order'
end

group :system_tests do
  # beaker-rspec will require beaker gem
  if RUBY_VERSION >= '2.2.5'
    gem 'beaker'
  else
    gem 'beaker', '< 3'
  end
  gem 'pry'
  gem 'beaker-rspec'
  gem 'beaker-docker'
  gem 'serverspec'
  gem 'beaker-hostgenerator'
  gem 'beaker-puppet_install_helper'
  gem 'master_manipulator'
end

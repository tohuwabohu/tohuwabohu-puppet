source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 10.1.1'
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-puppet', '~> 1.0.1'
  gem 'puppetlabs_spec_helper', '~> 0.8.2'
  gem 'puppet-blacksmith', '~> 3.3.1'
  gem 'puppet-lint', '~> 1.1.0'
  gem 'puppet-syntax', '~> 2.0.0'
end

group :system_tests do
  gem 'beaker', '~> 1.19.1'
  gem 'beaker-rspec', '~> 3.0.0'
  gem 'serverspec', '~> 1.7.0'
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 3.8.3'
end

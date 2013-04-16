source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'
gem "active_model_serializers", "~> 0.7.0"
gem 'strong_parameters'
gem 'jquery-rails'

group :development do
  #gems for file notifications according to platform
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  gem "guard"
  gem 'debugger', :require => 'ruby-debug'
  gem "spork-rails"
  gem "guard-rspec"
  gem "guard-spork"
  gem "zeus"
end

group :test do
  gem "database_cleaner"
  gem 'factory_girl_rails', '~> 3.0'
  gem 'rspec-rails', "~> 2.0"
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
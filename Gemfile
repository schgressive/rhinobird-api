source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2'
gem "active_model_serializers", "~> 0.8.0"
gem 'strong_parameters'
gem 'jquery-rails'
gem 'ruby-hmac'
gem 'friendly_id'
gem 'paperclip', "~> 3.0"
gem 'rack-cors', :require => 'rack/cors'
gem 'devise'
gem 'twitter-text'
gem 'negroku', "~> 1.1.4"

group :development do
  gem 'debugger', :require => 'ruby-debug'
end

group :test do
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem 'coveralls', require: false
end

#rspec-rails needs to be in both groups for shoulda-matchers to work
group :development, :test do
  gem 'guard-rspec'
  gem 'rspec-rails', "~> 2.0"
  gem "zeus"
  gem 'factory_girl_rails', '~> 3.0'
  gem "faker"
end

group :production do
  gem 'unicorn'
end

source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'thin'
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
gem 'ngmin-rails'

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

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'turbo-sprockets-rails3'
end

group :production do
  gem 'unicorn'
end

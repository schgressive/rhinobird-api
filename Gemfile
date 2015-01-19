source 'https://rubygems.org'

gem 'rails', '3.2.17'

gem 'thin'
gem 'mysql2'
gem "active_model_serializers", "~> 0.8.0"
gem 'strong_parameters'
gem 'ruby-hmac'
gem 'friendly_id'
gem 'paperclip', "~> 3.0"
gem 'aws-sdk'
gem 'rack-cors', :require => 'rack/cors'
gem 'twitter-text'
gem 'geocoder'
gem 'kaminari'
gem 'cancancan'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'koala'
gem 'twitter'

gem "aws-ses", "~> 0.5.0", :require => 'aws/ses'
gem 'devise'
gem 'enumerize'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

gem 'compass_twitter_bootstrap'
gem 'jquery-ui-rails', '~> 4.2.1'
gem 'compass-rails'

gem 'devise-async'
gem 'sidekiq'
gem 'draper'
gem 'whenever', require: false

gem 'newrelic_rpm'

group :test do
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem 'email_spec'
  gem 'timecop'
  gem 'coveralls', require: false
  gem 'fb_graph-mock'
end

#rspec-rails needs to be in both groups for shoulda-matchers to work
group :development, :test do
  gem 'letter_opener'
  gem 'guard-rspec'
  gem 'rspec-rails', "~> 2.14"
  gem 'terminal-notifier-guard'
  gem 'factory_girl_rails', '~> 3.0'
  gem "faker"
  gem "pry-byebug"
  # Deploy
  gem 'capistrano', '~> 3.3'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'capistrano3-unicorn', '0.2.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-nc', '~> 0.1'
  gem 'negroku', github: 'zevarito/negroku', ref: 'e7f4087ce19a2450716919dc5882ae8e21829067'
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

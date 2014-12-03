#########################################
# Negroky deploy.rb configuration file
#
# There are three types of settings here
#  * Capistrano settings
#  * Gem specific settings
#  * Negroku settings

set :application,   "rhinobird-api"
set :repo_url,      'https://github.com/rhinobird/rhinobird-api.git'
set :deploy_to,     "/home/deploy/applications/#{fetch(:application)}"

linked_files = Set.new(fetch(:linked_files, [])) # https://github.com/capistrano/rails/issues/52
linked_files.merge(%w{})
set :linked_files, linked_files.to_a

linked_dirs = Set.new(fetch(:linked_dirs, [])) # https://github.com/capistrano/rails/issues/52
linked_dirs.merge(%w{log tmp/pids tmp/cache tmp/sockets public/system})
set :linked_dirs, linked_dirs.to_a

set :nginx_use_ssl, true

set :nginx_ssl_certificate, 'rhinobird.crt'
set :nginx_ssl_certificate_key,  'rhinobird.key'

set :nginx_template, "#{stage_config_path}/#{fetch :stage}/nginx.conf.erb"

# Sidekiq
set :pty, false
set :sidekiq_queue, ['default', 'mailer']
set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')

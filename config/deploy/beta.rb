## BETA CONFIGURATION
set :rails_env, :production

set :application,   'rhinobird-api-beta'

set :nginx_domains, "api.rhinobird.tv"
set :branch, "beta"

server 'church.rhinobird.tv', user: 'deploy', roles: %w{web app db}

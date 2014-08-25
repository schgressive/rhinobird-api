## BETA CONFIGURATION
set :rails_env, :production

set :nginx_domains, "api.staging.rhinobird.tv"
set :branch, "master"

server 'godel.rhinobird.tv', user: 'deploy', roles: %w{web app db}

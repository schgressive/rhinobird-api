## BETA CONFIGURATION
set :rails_env, :production

set :nginx_domains, "api.beta.rhinobird.tv"
set :branch, "production"

server 'church.rhinobird.tv', user: 'deploy', roles: %w{web app db}

# Set server stages
set :stages, %w(production beta)
set :default_stage, "beta"
require 'capistrano/ext/multistage'

# Server-side information.
set :application, "rhinobird-api"
set :user,        "deploy"
set :deploy_to,   "/home/#{user}/applications/#{application}"

# Repository (if any) configuration.
set :deploy_via, :remote_cache
set :repository, "https://github.com/rhinobird/rhinobird-api.git"
# set :git_enable_submodules, 1

# Database
# set :migrate_env,    "migration"

# Unicorn
set :unicorn_workers, 1

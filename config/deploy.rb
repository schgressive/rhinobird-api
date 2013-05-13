# Servers and their roles.
server "church.peepol.tv", :web, :app, :db, primary: true

# Server-side information.
set :application, "peepoltv-api"
set :user,        "deploy"
set :deploy_to,   "/home/#{user}/applications/#{application}"

# Repository (if any) configuration.
set :deploy_via, :remote_cache
set :repository, "https://github.com/peepoltv/peepoltv-api.git"
set :branch,     "master"   # Optional, defaults to master
# set :remote,   "negroku"      # Optional, defaults to origin
# set :git_enable_submodules, 1

# Web server configuration
set :domains, "api.peepol.tv"

# Rails
# set :rails_env, 		"production"

# Database
# set :migrate_env,    "migration"

# Unicorn
set :unicorn_workers, 1

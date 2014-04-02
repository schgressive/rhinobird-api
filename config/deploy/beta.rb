## STAGING CONFIGURATION

# Servers and their roles.
server "church.rhinobird.tv", :web, :app, :db, primary: true

# Web server configuration
set :domains,		"beta.api.rhinobird.tv"

# Source
set :branch,     	"beta"		# Optional, defaults to master
# set :remote,   	"origin"			# Optional, defaults to origin

# Rails
# set :rails_env, 	"staging"		# Optional, defaults to production

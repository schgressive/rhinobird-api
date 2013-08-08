## PRODUCTION CONFIGURATION

# Servers and their roles.
server "godel.peepol.tv", :web, :app, :db, primary: true

# Web server configuration
set :domains, 		"api.peepol.tv"

# Source
set :branch,     	"production"		# Optional, defaults to master
# set :remote,   	"origin"			# Optional, defaults to origin

# Rails
# set :rails_env, 	"production"		# Optional, defaults to production

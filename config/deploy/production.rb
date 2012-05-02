# Set up production code
server "FiniteStateWeb", :app, :web, :db, :primary => true
set :deploy_to, "/var/www/apps/hexedguild"
set :deploy_via, :remote_cache

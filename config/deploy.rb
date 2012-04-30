# Application Name
set :application, "hexedguild"

# Repo details
set :scm, :git
set :repository,  "git@github.com:slander36/hexedguild.git"
set :branch, "master"

# Login details
set :user, "sl36"
set :use_sudo, false

# Server login details
server "finitestategames.com", :app, :web, :db, :primary => true
set :port, 2222

# App path
set :deploy_to, "/home/sl36/rails_apps/"
set :deploy_via, :remote_cache

# Excludes on deploy
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# Tell Capistrano to ping remote connection for password info
ssh_options[:forward_agent] = true

# Set up multi-stage
require 'capistrano/ext/multistage'

set :stages, ["staging", "production"]
set :default_stage, "staging"

# Application Name
set :application, "hexedguild"

# Repo details
set :scm, :git
set :repository,  "git@github.com:slander36/hexedguild.git"
set :branch, "master"
set :scm_password, "turket"

# Login details
set :user, "hexedguild"
set :password, "hexedguild_pass"
set :use_sudo, false

# Server login details
server "67.207.142.196", :app, :web, :db, :primary => true

# App path
set :deploy_to, "/var/www/apps/hexedguild/"
set :deploy_via, :remote_cache

# Excludes on deploy
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]

### Using Capistrano/RVM Gem ###

require "rvm/capistrano"
require "bundler/capistrano"

# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
set :rvm_ruby_string, '1.9.3@hexedguild'

# Tell Capistrano to install rvm, ruby, etc on deploy:setup
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

# Tell Capistrano to update rvm on every deploy
before 'deploy', 'rvm:install_rvm'

### End Capistrano/RVM Gem ###

namespace :deploy do
# task :start {}
# task :stop {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


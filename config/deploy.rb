# Set up multi-stage
require 'capistrano/ext/multistage'

set :stages, ["staging", "production"]
set :default_stage, "staging"

### Using Capistrano/RVM Gem ###

require "rvm/capistrano"
require "bundler/capistrano"

# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
set :rvm_ruby_string, '1.9.3@hexedguild'

# Application Name
set :application, "hexedguild.com"
role :web, application
role :app, application
role :db, application, :primary => true

# Server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache

# Login details
set :user, "hexedguild"
set :password, "hexedguild_pass"
set :use_sudo, false

# Repo details
set :scm, :git
set :repository,  "git@github.com:slander36/hexedguild.git"
set :branch, "master"
set :git_enable_submodules, 1

# Excludes on deploy
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]

before "deploy:symlink", "assets:precompile"

namespace :deploy do
	task :start, :roles => :app do
		run "touch #{current_path}/tmp/restart.txt"
	end

  task :stop do
	end

	desc "Restart Application"
	task :restart, :roles => :app do
		run "touch #{current_path}/tmp/restart.txt"
	end
end

namespace :assets do
	desc "Compile assets"
	task :precompile, :roles => :app do
		run "cd #{release_path} && bundle exec rake RAILS_ENV=#{rails_env} assets:precompile"
	end
end

after "deploy", "deploy:cleanup"


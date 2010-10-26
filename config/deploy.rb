#############################################################
# Application
#############################################################

set :application, "qualidade"
set :deploy_to,   "/rails_apps/#{application}"

#############################################################
# Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true

#############################################################
# Servers
#############################################################

set :user, "root"
set :user_passphrase, "072029"
set :domain, "184.106.132.230"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
# Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, "gilsantana"
set :scm_passphrase, "072029"
set :repository, "git://github.com/gilsantana/cep.git"
set :deploy_via, :remote_cache

#############################################################
# Server Setup
#############################################################

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
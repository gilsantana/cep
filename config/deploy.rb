set :application, "qualidade"

#github stuff
set :repository,  "git://github.com/gilsantana/cep.git"
set :scm, :git
set :scm_username, "gilsantana"
set :scm_passphrase, "072029"

set :use_sudo,    true
set :deploy_to,   "/rails_apps/#{application}"

#server login
set :user, "root"
set :password, "072029"

#ssh_options[:forward_agent] = true

# will be different entries for app, web, db if you host them on different servers
server "184.106.132.230", :app, :web, :db, :primary => true

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
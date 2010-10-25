#############################################################
# Application
#############################################################

set :application, "qualidade"
set :deploy_to, "/root/deploy/#{application}"

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

set :user, "sanderson"
set :user_passphrase, "072029"
set :domain, "192.168.1.103"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
# Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, "gilsantana"
# set :scm_passphrase, "GITPASSWORD"
set :repository, "git://github.com/gilsantana/cep.git"
set :deploy_via, :remote_cache

#############################################################
# Server Setup
#############################################################

task :teste do
  echo ""
end

namespace :server_setup do
  desc "Setup Environment"
  task :setup_env do
    update_apt_get
    install_dev_tools
    install_git
    install_sqlite3
    install_rails_stack
    install_apache
    install_passenger
    config_passenger
    config_vhost
  end
  
  desc "Aliases"
  task :aliases do
    sudo "echo \"alias ll='ls -l'\" >> ~/.bash_aliases"
    sudo "echo \"alias sudo='sudo env PATH=$PATH'\" >> ~/.bash_aliases"
  end

  desc "Update apt-get sources"
  task :update_apt_get do
    sudo "apt-get install python-software-properties -y"
    sudo "add-apt-repository ppa:pitti/postgresql"
    sudo "apt-get update"
  end

  desc "Install Development Tools"
  task :install_dev_tools do
    sudo "apt-get install build-essential zlib1g-dev libssl-dev libreadline5-dev -y"
  end

  desc "Install Git"
  task :install_git do
    sudo "apt-get install git-core git-svn -y"
  end

  desc "Install Subversion"
  task :install_subversion do
    sudo "apt-get install subversion -y"
  end

  desc "Install MySQL"
  task :install_mysql do
    sudo "apt-get install mysql-server libmysql-ruby libmysqlclient15-dev -y"
  end

  desc "Install PostgreSQL"
  task :install_postgres do
    sudo "apt-get install postgresql-9.0 libpq-dev libpgsql-ruby -y"
  end

  desc "Install SQLite3"
  task :install_sqlite3 do
    sudo "apt-get install sqlite3 libsqlite3-ruby -y"
  end

  desc "Install Ruby, Gems, and Rails"
  task :install_rails_stack do
    [ "sudo apt-get install ruby ruby1.8-dev irb ri rdoc libopenssl-ruby1.8 -y",
      "mkdir -p src",
      "cd src",
      "wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz",
      "tar xzvf rubygems-1.3.5.tgz",
      "cd rubygems-1.3.5/ && sudo ruby setup.rb",
      "sudo ln -s /usr/bin/gem1.8 /usr/bin/gem",
      "sudo gem update --system",
      "sudo gem install rails --no-ri --no-rdoc"
    ].each {|cmd| run cmd}
  end

  desc "Install MySQL Rails Bindings"
  task :install_mysql_bindings do
    sudo "aptitude install libmysql-ruby1.8"
  end

  desc "Install ImageMagick"
  task :install_imagemagick do
    sudo "apt-get install libxml2-dev libmagick9-dev imagemagick -y"
    sudo "gem install rmagick"
  end

  desc "Install Apache"
  task :install_apache do
    sudo "apt-get install apache2 apache2.2-common apache2-mpm-prefork
          apache2-utils libexpat1 apache2-prefork-dev libapr1-dev -y"
    sudo "chown :sudo /var/www"
    sudo "chmod g+w /var/www"
  end

  desc "Install Passenger"
  task :install_passenger do
    run "sudo apt-get install libcurl4-openssl-dev -y"
    run "sudo gem install passenger --no-ri --no-rdoc"
    input = ''
    run "sudo passenger-install-apache2-module" do |ch,stream,out|
      next if out.chomp == input.chomp || out.chomp == ''
      print out
      ch.send_data(input = $stdin.gets) if out =~ /(Enter|ENTER)/
    end
  end

  desc "Configure Passenger"
  task :config_passenger do
    
    passenger_version = `gem search passenger`.scan(/(?:\(|, *)([^,)]*)/).flatten.first    
    
    passenger_config =<<-EOF
LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-#{passenger_version}/ext/apache2/mod_passenger.so
PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-#{passenger_version}
PassengerRuby /usr/bin/ruby1.8    
    EOF
    put passenger_config, "src/passenger"
    sudo "mv src/passenger /etc/apache2/conf.d/passenger"
  end

  desc "Configure VHost"
  task :config_vhost do
    vhost_config =<<-EOF
    <VirtualHost *:80>
      ServerName localhost
      DocumentRoot #{deploy_to}/current/public
    </VirtualHost>
    EOF
    put vhost_config, "src/vhost_config"
    sudo "mv src/vhost_config /etc/apache2/sites-available/#{application}"
    sudo "a2ensite #{application}"
    sudo "sudo a2enmod rewrite"
  end

  desc "Reload Apache"
  task :apache_reload do
    sudo "/etc/init.d/apache2 reload"
  end
end

#############################################################
# Deploy for Passenger
#############################################################

namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
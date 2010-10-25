set(:domain) do
  Capistrano::CLI.ui.ask "Which domain should we use? "
end

set :nginx_path, "/opt/nginx"

namespace :nginx do
  desc "Restarts Nginx webserver"
  task :restart, :roles => :web do
    sudo "/etc/init.d/nginx restart"
  end

  desc "Starts Nginx webserver"
  task :start, :roles => :web do
    sudo "/etc/init.d/nginx start"
  end

  desc "Stops Nginx webserver"
  task :stop, :roles => :web do
    sudo "/etc/init.d/nginx stop"
  end

  desc "Reload Nginx webserver"
  task :reload, :roles => :web do
    sudo "/etc/init.d/nginx reload"
  end

  desc "Force reload Nginx webserver"
  task :force_reload, :roles => :web do
    sudo "/etc/init.d/nginx force-reload"
  end

  desc "List enabled Nginx sites"
  task :enabled_sites, :roles => :web do
    run "ls #{nginx_path}/sites-enabled"
  end

  desc "List available Nginx sites"
  task :available_sites, :roles => :web do
    run "ls #{nginx_path}/sites-available"
  end

  desc "Disable Nginx site"
  task :disable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we disable: ")
    sudo "rm #{nginx_path}/sites-enabled/#{site}"
    reload
  end

  desc "Enable Nginx site"
  task :enable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we enable: ")
    sudo "ln -s #{nginx_path}/sites-available/#{site} #{nginx_path}/sites-enabled/#{site}"
    reload
  end
  
  desc "Upload Nginx virtual host"
  task :upload_vhost, :roles => :web do
    put render("vhost_nginx", binding), application
    sudo "mv #{application} #{nginx_path}/sites-available/#{application}"
  end

  desc "Install Nginx"
  task :install, :roles => :web do
     sudo "passenger-install-nginx-module --auto --auto-download --prefix #{nginx_path} "
     sudo "mkdir #{nginx_path}/sites-available"
     sudo "mkdir #{nginx_path}/sites-enabled"
  end

end

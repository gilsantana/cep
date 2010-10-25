require 'net/http'

set :ruby_enterprise_url do
  Net::HTTP.get('www.rubyenterpriseedition.com', '/download.html').scan(/http:.*\.tar\.gz/).first
end

set :ruby_enterprise_version do
  "#{ruby_enterprise_url[/(ruby-enterprise.*)(.tar.gz)/, 1]}"
end

namespace :ruby do
  desc "Install Ruby 1.8"
  task :setup_18, :roles => :app do
    sudo "aptitude install -y ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8"
    sudo "ln -s /usr/bin/ruby1.8 /usr/bin/ruby"
    sudo "ln -s /usr/bin/ri1.8 /usr/bin/ri"
    sudo "ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc"
    sudo "ln -s /usr/bin/irb1.8 /usr/bin/irb"
  end

  desc "Install Ruby 1.9"
  task :setup_19, :roles => :app do
    sudo "aptitude -q -y install libc6-dev libssl-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline5-dev zlib1g-dev"
    run "wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz"
    run "tar zxvf ruby-1.9.1-p243.tar.gz"
    run "cd ruby-1.9.1-p243"
    run "./configure"
    run "make"
    sudo "make install"
  end
  
  desc "Install Ruby Enterpise Edition"
  task :install_enterprise, :roles => :app do
    sudo "aptitude install -y libssl-dev"
    sudo "aptitude install -y libreadline5-dev"
    run "test ! -d /opt/#{ruby_enterprise_version}"
    run "wget -q #{ruby_enterprise_url}"
    run "tar xzvf #{ruby_enterprise_version}.tar.gz"
    run "rm #{ruby_enterprise_version}.tar.gz"
    sudo "./#{ruby_enterprise_version}/installer --auto /opt/#{ruby_enterprise_version}"
    sudo "rm -rf #{ruby_enterprise_version}/"
  end

  desc "Install Phusion Passenger"
  task :install_passenger_apache, :roles => :app do
    sudo "apt-get install apache2-mpm-prefork"
    sudo "aptitude install -y apache2-prefork-dev"
    sudo "gem install passenger -v #{passenger_version}"
    sudo "passenger-install-apache2-module --auto"

    put render("passenger.load", binding), "/home/#{user}/passenger.load"
    put render("passenger.conf", binding), "/home/#{user}/passenger.conf"

    sudo "mv /home/#{user}/passenger.load /etc/apache2/mods-available/"
    sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"

    sudo "a2enmod passenger"
    apache.force_reload
  end
end

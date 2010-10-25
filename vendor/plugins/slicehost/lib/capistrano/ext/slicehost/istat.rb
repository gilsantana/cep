namespace :istat do
  desc "Setup istat daemon for monitoring with iStat for iPhone."
  task :setup, :roles => :web do
    sudo "aptitude install g++ libxml-dev build-essential"
    run "wget http://github.com/downloads/tiwilliam/istatd/istatd-0.5.7.tar.gz -O /home/#{user}"
    run "tar -zxvf /home/#{user}/istatd-0.5.7.tar.gz"
    run "/home/#{user}/istatd-0.5.7/configure"
    run "/home/#{user}/istatd-0.5.7/make"
    sudo "/home/#{user}/istatd-0.5.7/make install"
    sudo "useradd istat"
    sudo "mkdir /var/run/istat"
    sudo "chown istat /var/run/istat"
    sudo "/usr/local/bin/istatd -d"
    put render("istatdlauncher", binding), "istatdlauncher"
    sudo "mv istatdlauncher /etc/init.d/istatdlauncher"
    sudo "chmod +x /etc/init.d/istatdlauncher"
    sudo "update-rc.d istatdlauncher defaults"
  end
end
namespace :iptables do
  desc <<-DESC
    Harden iptables configuration. Only allows ssh, http, and https connections.

    See "iptables" section on \
    http://articles.slicehost.com/2008/4/25/ubuntu-hardy-setup-page-1
  DESC
  task :configure, :roles => :gateway do
    put render("iptables", binding), "iptables.up.rules"
    sudo "mv iptables.up.rules /etc/iptables.up.rules"

    if capture("cat /etc/network/interfaces").grep(/iptables/).empty?
      run %(cat /etc/network/interfaces |
        sed '/iface lo inet loopback/G' |
        sed -e '6s/.*/pre-up iptables-restore < \\/etc\\\/iptables.up.rules/' >
        interfaces
      )
      sudo "mv interfaces /etc/network/interfaces"
    end
    
    sudo "iptables-restore < /etc/iptables.up.rules"
    sudo "iptables-save > /etc/iptables.up.rules"
    
    put render("iptables_reboot", binding), "iptables_reboot"
    sudo "mv iptables_reboot /etc/network/if-pre-up.d/iptables_reboot"
    sudo "chmod +x /etc/network/if-pre-up.d/iptables_reboot"
    
  end
end
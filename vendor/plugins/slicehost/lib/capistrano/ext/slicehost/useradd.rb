ssh_options = { :keys => [File.expand_path("~/.ssh/id_dsa"),File.expand_path("~/.ssh/id_rsa") ], :port => 22 }

namespace :useradd do

	def ask_with_default(var, default)
		set(var) do
			Capistrano::CLI.ui.ask "#{var}? [#{default}] : "
		end
		
		set var, default if eval("#{var.to_s}.empty?")
	end

  desc <<-DESC
    Check that %sudo entry exists in the /etc/sudoers file. If the entry \
    for the sudo group is not found then %sudo ALL=NOPASSWD: ALL is appended \
    to the file. This makes it easy to create sudo users with this command.
    
    NOTE: this tasks requires the role 'gateway_as_root', i.e., root@host.com.
  DESC
	task :check_sudoers, :roles => :gateway_as_root do    	
      sudo <<-END
        sh -c 'grep -F "^%sudo " /etc/sudoers > /dev/null 2>&1 || test ! -f /etc/sudoers || echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers'
      END
  end

  desc <<-DESC
    Interactive adduser with login, groups and shell.
    
    Creates a login account on the remote host and uploads your local \
    public SSH keys to the server. The keys are placed into the .ssh folder of \
    the newly created account.
    
    A final check is done to make sure %sudo entry exists in the \
    /etc/sudoers file. If the entry for the sudo group is not found then %sudo \   
    ALL=NOPASSWD: ALL is appended to the file. This makes it easy to create sudo \
    users with this command.
    
    NOTE: this tasks requires the role 'gateway_as_root', i.e., root@host.com.
  DESC
	task :setup, :roles => :gateway_as_root do    	
		ask_with_default(:username, user)
		ask_with_default(:groups, "users,sudo")
		ask_with_default(:login_shell, "/bin/bash")
	
    authorized_keys = ssh_options[:keys].collect { |key|
      begin
        File.read("#{key}.pub")
      rescue Errno::ENOENT
      end
    }.join("\n")
 
		sudo "useradd -s #{login_shell} -G #{groups} -m #{username}"
    
    put(authorized_keys, 
      "/tmp/authorized_keys.#{username}.tmp", :mode => 0600 )
    cmds = [
        "mkdir -p ~#{username}/.ssh",
        "mv /tmp/authorized_keys.#{username}.tmp ~#{username}/.ssh/authorized_keys",
        "chown -R #{username}:#{username} ~#{username}/.ssh",
        "chmod 700 ~#{username}/.ssh"
      ]
      cmds.each do |cmd|
        sudo cmd
      end
    
    check_sudoers
	end
end
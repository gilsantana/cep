namespace :vim do  
  desc "setup vim on slicehost" 
  task :setup, :roles => :files do
    install
    load_vimrc
  end  

  desc "install vim from aptitude"
  task :install, :roles => :files do
    sudo "aptitude install -y vim"
  end
  
  desc "load up a simple .vimrc"
  task :load_vimrc, :roles => :files do
    put render("vimrc", binding), "/home/#{user}/.vimrc"
  end
  
  
end
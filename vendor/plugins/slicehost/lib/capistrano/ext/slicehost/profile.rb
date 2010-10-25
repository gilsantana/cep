namespace :profile do
  desc "Setup .bashrc the way we like it and add directory colors."
  task :configure, :roles => :web do
    run "mv .bashrc /home/#{user}/.bashrc.bak"
    put render("bashrc", binding), ".bashrc"
    put render("mydircolors", binding), ".mydircolors"
    sudo "mv /etc/nanorc /etc/nanorc.bak"
    put render("nanorc", binding), "nanorc"
    sudo "mv nanorc /etc/nanorc"
  end
end
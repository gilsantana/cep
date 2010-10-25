namespace :postgresql do
  desc "Restarts PostgreSQL database server"
  task :restart, :roles => :db do
    sudo "/etc/init.d/postgresql-8.3 restart"
  end

  desc "Starts PostgreSQL database server"
  task :start, :roles => :db do
    sudo "/etc/init.d/postgresql-8.3 start"
  end

  desc "Stops PostgreSQL database server"
  task :stop, :roles => :db do
    sudo "/etc/init.d/postgresql-8.3 stop"
  end

  desc "Export PostgreSQL database"
  task :export, :roles => :db do
    database = Capistrano::CLI.ui.ask("Which database should we export: ")
    username = Capistrano::CLI.ui.ask("Username: ")
    sudo "pg_dump -U #{username} #{database} > #{database}.sql"
  end

  desc "Import PostgreSQL database"
  task :import, :roles => :db do
    database = Capistrano::CLI.ui.ask("Which database should we create: ")
    username = Capistrano::CLI.ui.ask("Username: ")
    file     = Capistrano::CLI.ui.ask("Which database file should we import: ")
    sudo "createdb -U #{username} #{database}"
    sudo "pg_restore -U #{username} -d #{database} < #{file}"
  end

  desc "Install PostgreSQL"
  task :install, :roles => :db do
    sudo "aptitude install -y postgresql"
  end
end

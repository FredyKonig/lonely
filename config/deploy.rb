default_run_options[:pty] = true # Must be set for the password prompt from git to work

require 'bundler/capistrano'

set :application, "lonely" # Your application location on your server goes here

set :scm, :git #repository type
set :repository,  "git@github.com:FredyKonig/lonely.git" # Your clone URL

set :stages, %w(staging production) #available environment
set :default_stage, "staging" #default environment
require 'capistrano/ext/multistage' #options for using multi environment

#set :deploy_to, "/var/www/#{application}" #path destination
set :deploy_to, "/var/www/myapp" #path destination


set :deploy_via, :checkout

#before "deploy", "deploy:setup_env"

# creates the directory for the monit scripts if it does not exist
task :check_monit_directory do
  sudo "test -d '/etc/monit/conf.d' || #{sudo} mkdir /etc/monit/conf.d"
end

after "deploy:setup", :check_monit_directory

task :symlink_monit_file do
  with_role :web do
    run "(test -L /etc/monit/conf.d/myapp && #{sudo} rm /etc/monit/conf.d/myapp) || echo 'no existing path monit file symlink'"
    sudo "ln -s #{current_path}/config/monit/#{stage} /etc/monit/conf.d/myapp"
  end
end
after "deploy:symlink", :symlink_monit_file


namespace :deploy do
  task :stop, :on_error => :continue do
    with_role :web do
      sudo "monit stop -g myapp"
    end
  end

  task :start, :on_error => :continue do
    with_role :web do
      sudo "monit reload"
      sleep 5
      sudo "monit start -g myapp"
    end
  end

end


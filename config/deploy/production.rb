#require "bundler/capistrano"

set :user, "master" # The server's user for deploys

set :use_sudo, true # options to enable sudo

set :ssh_options, {
  :keys => %w(~/.ssh/id_rsa), # location for the ssh keys /home/rakotobe/.ssh/id_rsa
  :forward_agent => true
}

set :port, 224 # server port to make ssh auth
server "176.58.110.189", :app, :web, :db, :primary => true # list of the server


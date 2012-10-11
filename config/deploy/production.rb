require "bundler/capistrano"

set :user, "master" # The server's user for deploys

set :use_sudo, true # options to enable sudo

set :ssh_options, {
  :keys => %w(~/.ssh/id_rsa), # location for the ssh keys /home/rakotobe/.ssh/id_rsa
  :forward_agent => true
}

set :port, 224 # server port to make ssh auth
server "176.58.110.189", :app, :web, :db, :primary => true # list of the server

set :default_environment, {
   'PATH' => "/home/master/.rvm/gems/ree-1.8.7-2012.02/bin:/home/master/.rvm/gems/ree-1.8.7-2012.02@global/bin:/home/master/.rvm/rubies/ree-1.8.7-2012.02/bin:/home/master/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
   'RUBY_VERSION' => 'ruby 1.8.7',
   'GEM_HOME'     => "/home/master/.rvm/gems/ree-1.8.7-2012.02",
   'GEM_PATH'     => "/home/master/.rvm/gems/ree-1.8.7-2012.02:/home/master/.rvm/gems/ree-1.8.7-2012.02@global"
   #'BUNDLE_PATH'  => '/home/deploy/.rvm/gems/ruby-1.8.7-p302@leadnuke'  # If you are using bundler.
  }


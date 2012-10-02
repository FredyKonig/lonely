default_run_options[:pty] = true

require 'bundler/capistrano'

set :application, "lonely"
set :repository,  "git@github.com:FredyKonig/lonely.git"

set :scm, :git

set :deploy_to, "/var/www/#{application}"

set :deploy_via, 'remote_cache'

set :ssh_options, {
  :forward_agent => true
}

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

role :app, "127.0.0.1"
role :web, "127.0.0.1"
role :db, "127.0.0.1", :primary => true


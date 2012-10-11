default_run_options[:pty] = true # Must be set for the password prompt from git to work

require 'bundler/capistrano'

set :application, "lonely" # Your application location on your server goes here

set :scm, :git #repository type
set :repository,  "git@github.com:FredyKonig/lonely.git" # Your clone URL

set :stages, %w(staging production) #available environment
set :default_stage, "staging" #default environment
require 'capistrano/ext/multistage' #options for using multi environment

set :deploy_to, "/var/www/#{application}" #path destination

set :deploy_via, :checkout

#before "deploy", "deploy:setup_env"


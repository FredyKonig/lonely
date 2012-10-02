require 'bundler/capistrano'

server "localhost", :app, :web, :db, :primary => true


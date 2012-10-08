set :user, "rakotobe"

set :use_sudo, true

set :ssh_options, {
  :keys => %w(~/.ssh/id_rsa),
  :forward_agent => true
}

set :port, 224
server "127.0.0.1", :app, :web, :db, :primary => true


set :user, "master" # The server's user for deploys
set :password, "THEking21"

set :use_sudo, false # options to enable sudo

set :ssh_options, {
  #:keys => %w(~/.ssh/id_rsa), # location for the ssh keys /home/rakotobe/.ssh/id_rsa
  :forward_agent => true
}

set :port, 224 # server port to make ssh auth
server "176.58.110.189", :app, :web, :db, :primary => true # list of the server


#setup environment

namespace :deploy do
  desc "Setup environment"
  task :setup_env, :roles => :app do
    update_apt_get
    install_dev_tools
    install_git
    setup_rvm
    install_imagemagick
  end

  desc "Setup RVM environment with Rails"
  task :setup_rvm, :roles => :app do
    install_rvm
    install_rvm_ruby
  end


  desc "Update apt-get sources"
   task :update_apt_get, :roles => :app do
     sudo "apt-get update"
   end

  desc "Install and setup RVM"
  task :install_rvm, :roles => :app do
    # https://github.com/wayneeseguin/rvm/raw/master/contrib/install-system-wide
    sudo "curl -L https://get.rvm.io | sudo bash -s stable", :shell => false
    puts <<-EOS
    Put this at the end of ~/.bashrc:
      [[ -s "/usr/local/lib/rvm" ]] && . "/usr/local/lib/rvm"  # This loads RVM into a shell session.
    EOS
    run "source /usr/local/lib/rvm", :shell => false
    sudo "adduser #{user} rvm"
  end

  desc "Install RVM ruby and set as default"
  task :install_rvm_ruby, :roles => :app do
    sudo "rvm install 1.8.7"
    sudo "rvm --default use 1.8.7"
  end

  desc "Install Development Tools"
  task :install_dev_tools, :roles => :app do
     sudo "apt-get install build-essential -y"
  end

  desc "Install Git"
  task :install_git, :roles => :app do
    sudo "apt-get install git-core git-svn -y"
  end

end


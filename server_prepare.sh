#!/bin/bash

#install rvm
sudo curl -L https://get.rvm.io | bash -s stable
sudo source /usr/local/lib/rvm
sudo adduser $(whoami) rvm

#install ruby
rvm install ree


#!/bin/sh
# Update the image
sudo apt-get update
sudo apt-get install -y software-properties-common

# Install necessary packages
sudo apt-get install -y zsh make vim tmux curl wget nginx php5-fpm php5-mcrypt php5-curl php5-cli php5-pgsql git zip unzip

# Install postgresql
echo "Writing /etc/apt/sources.list.d/pgdg.list ..."
sudo cat > /etc/apt/sources.list.d/pgdg.list <<EOF
deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
EOF
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql 

# Install composer
sudo -u vagrant -H curl -sS https://getcomposer.org/installer | sudo -u vagrant -H php
sudo mv composer.phar /usr/local/bin/composer

# Change setting for vagrant user
cd /home/vagrant
# Install oh-my-zsh
chsh -s /bin/zsh vagrant
sudo -u vagrant -H curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sudo -u vagrant -H sh

# Add dotfiles
sudo -u vagrant -H git clone https://github.com/linhmtran168/rails_vagrant_dotfiles.git /home/vagrant/dotfiles
sudo -u vagrant -H ln -sf /home/vagrant/dotfiles/.zshrc /home/vagrant/.zshrc
sudo -u vagrant -H ln -sf /home/vagrant/dotfiles/.tmux.conf /home/vagrant/.tmux.conf

# Update the project folder
cd /vagrant && sudo -u vagrant -H composer install

# Start enginex
sudo service nginx start

su
sudo apt-get install git sudo stow
usermod -aG sudo <USERNAME TO ADD>
exit
login for sudo membership to work

*Pull repo*
git clone --recurse-submodules --jobs 8 https://github.com/pjfoley/dotfiles-stow.git ~/.dotfiles

To update git pull --recurse-submodules --jobs 8

*Install Dotfiles*
.dotfiles/install

*Vim Install*
vim +PlugInstall +qall


*Things to do after install*
mv .bashrc .bashrc.org

vim
  - Install YouCompleteMe

Virtualbox
  - Under Debian Stretch I had an issue and needed to update the kernel.  Check uname -a, update to the next point release in my instance (sudo apt-get install linux-image-4.9.0-2-amd64  /sbin/vboxconfig)

DOCKER
 - add user to docker group (sudo usermod -aG docker $USER)

VIRTUALBOX
 - configure location for Virtualbox machines (vboxmanage setproperty machinefolder /path/to/directory/)
 - add user to docker group (sudo usermod -aG vboxusers $USER)
 - change folder group owner (sudo chgrp vboxusers /path/to/directory )
 - change folder group modes (sudo chmod -R g+srwx /path/to/directory )

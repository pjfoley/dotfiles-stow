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
vim +PluginInstall +qall


*Things to do after install*

vim
  - Install YouCompleteMe

Virtualbox
  - Under Debian Stretch I had an issue and needed to update the kernel.  Check uname -a, update to the next point release in my instance (apt-get install linux-image-4.9.0-2-amd64)

su
sudo apt-get install git sudo stow
usermod -aG sudo <USERNAME TO ADD>
exit
login for sudo membership to work

*Pull repo*
git clone --recurse-submodules --jobs 8 https://github.com/pjfoley/dotfiles-stow.git ~/.dotfiles

*Install Dotfiles*
.dotfiles/install

*Vim Install*
vim +PluginInstall +qall

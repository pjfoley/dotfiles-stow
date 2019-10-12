" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  echo 'vim-plug not installed, downloading'
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo 'vim-plug downloaded, will install plugins once vim loads'
  augroup VimPlugInstall
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
else
  " clear out install on enter
  augroup VimPlugInstall
    autocmd!
  augroup END
endif

"##############################################################################
" Plugins :
"##########
call plug#begin('~/.local/share/nvim/plugged')


Plug 'spf13/vim-autoclose'
Plug 'chriskempson/base16-vim'
" Intellisense Engine
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'tpope/vim-commentary'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'tag': 'v1.20', 'do': ':GoInstallBinaries' }
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'mxw/vim-jsx'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'hashivim/vim-terraform.git'
Plug 'tpope/vim-repeat'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-surround'
Plug 'othree/yajs.vim'
Plug 'HerringtonDarkholme/yats.vim'

call plug#end()
"##############################################################################

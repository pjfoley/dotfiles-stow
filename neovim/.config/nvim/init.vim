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

"##############################################################################
" Color-scheme :
"###############

" let base16colorspace=256
set background=dark
colorscheme base16-3024

set termguicolors
" Disables color-scheme background color
hi Normal guibg=NONE

" Have italic comments
hi Comment cterm=italic gui=italic

"##############################################################################

"##############################################################################
" Indentation :
"##############

set tabstop=4               " Number of visual spaces per Tab
set softtabstop=4           " Number of spaces in tab when editing
set shiftwidth=4            " Number of spaces to use for autoindent
set expandtab               " Tabs are spaces
set copyindent              " Copy the indentation from the previous line
set autoindent              " Automatically indent new lines

"##############################################################################

"##############################################################################
" Search :
"#########

set incsearch               " Search as characters are typed
set hlsearch                " Highlight matches
set ignorecase              " Ignore case when searching
set smartcase               " Ignore case when only lower case is typed

"##############################################################################

"##############################################################################
" Keybindings :
"##############

" Map leader to space bar
" Note: This line MUST come before any <leader> mappings
let mapleader = "\<space>"
let g:mapleader = "\<space>"

" Shortcut to edit THIS configuration file: (e)dit (c)onfiguration
nnoremap <silent> <leader>ec :e $MYVIMRC<CR>

" Shortcut to source (reload) THIS configuration file after editing it: (s)ource (c)onfiguraiton
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>



" toggle buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>

" go to next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <C-l> :bn<CR>

" go to previous buffer
nnoremap <silent> <leader>bp :bp<CR>
" https://github.com/neovim/neovim/issues/2048
nnoremap <C-h> :bp<CR>

" close buffer
nnoremap <silent> <leader>bd :bd<CR>

" kill buffer
nnoremap <silent> <leader>bk :bd!<CR>

" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader>bg :ls<CR>:buffer<Space>

" horizontal split with new buffer
nnoremap <silent> <leader>bh :new<CR>

" vertical split with new buffer
nnoremap <silent> <leader>bv :vnew<CR>

" Ctrl+[Left | Right] -> tabs navigation
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Ctrl+Up -> insert ':tabnew ' in the command line
nnoremap <C-Up> :tabnew <right>

" Ctrl+Down -> close the current tab (can't close the last one)
nnoremap <C-Down> :tabclose<CR>

" F2 -> Replaces TABs with spaces
nnoremap <F2> :retab <CR> :w! <CR>

" F3 -> Toggle the coloring of the 80th column
nnoremap <F3> :call ToggleCC()<CR>

" ù -> Disables the highlighting of matched regex ('ù' key is next to '*')
nnoremap ù :noh<CR>

" Ctrl+[C | P] -> Copy / Paste with system's clipboard
vnoremap <C-c> "+y<CR>
map <C-p> "+p

"##############################################################################

"##############################################################################
" Commands :
"###########

" Toggles the coloring of the 80th column
function! ToggleCC()
    if &cc == ''
        set cc=80
    else
        set cc=
    endif
endfunction

"##############################################################################

"##############################################################################
" Auto-commands :
"################

" Delete trailing whitespaces on save
autocmd BufRead,BufNewFile * %s/\s\+$//e

"##############################################################################

"##############################################################################
" Other settings :
"#################

set number                  " Line numbers
set rnu                     " Display line number relative to the current one
set cursorline              " Highlight the current line
set showmatch               " Highlight matching brackets
set scrolloff=3             " Minimum lines to keep above/below cursor
set wrap                    " Wrap long lines
filetype plugin on          " Necessary for the NERDcommenter plugin
set splitbelow splitright   " Invert vim's weird default spliting directions
set autochdir               " Automatically cd into the active vim buffer

"##############################################################################

"##############################################################################
" Language specific settings :
"#############################

" Javascript, HTML, CSS and XML
" Change the indent width to 2 spaces
au FileType javascript,html,css,xml
    \ setlocal tabstop=2 |
    \ setlocal softtabstop=2 |
    \ setlocal shiftwidth=2

"##############################################################################



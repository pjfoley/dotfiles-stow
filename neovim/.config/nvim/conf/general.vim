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

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile

"##############################################################################


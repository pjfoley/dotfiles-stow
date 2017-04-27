set nocompatible " Set to be non-compatible to vi

"""""""""""""""""""""""""""""
" => Vim directory path     "
" """""""""""""""""""""""""""
let $VIMHOME=expand('<sfile>:p:h')
if WINDOWS()
    let $VIMHOME=expand('$VIMHOME/vimfiles')
elseif OSX()
    let $VIMHOME=expand('$VIMHOME/.vim')
else
    let $VIMHOME=expand('$VIMHOME/.vim')
endif

" Map leader to space bar
" Note: This line MUST come before any <leader> mappings
let mapleader = "\<space>"
let g:mapleader = "\<space>"

"""""""""""""""""""""""""""
" => Setup vundle plugin  "
" """"""""""""""""""""""""""
if filereadable(expand("$VIMHOME/vimrc_bundles"))
  source $VIMHOME/vimrc_bundles
endif

""""""""""""""""""""""""""
"  => Colors and Scheme  "
""""""""""""""""""""""""""
set t_Co=256
set background=dark
try
  if filereadable(expand("$HOME/.vimrc_background"))
    source $HOME/.vimrc_background
  else
    colorscheme jellybeans
  endif
catch /E185:/
  colorscheme default
endtry
"""""""""""""""""""""""""""""""""""""""""""""""
"  => VIM user interface                      "
"""""""""""""""""""""""""""""""""""""""""""""""

set ruler          " Always show the ruler
set number         " Line Numbers on
set wrap
set cmdheight=2    " Height of the command bar
set encoding=utf-8 " set utf-8 as standard encoding
set lazyredraw     " Don't redraw while executing macros (good performance config)
set cursorline
set cursorcolumn

" number line settings {{{
" --------------------------------------------------------------------------------
if has ("autocmd")
  autocmd FocusLost * :set norelativenumber
  autocmd BufLeave * :set norelativenumber
  autocmd InsertEnter * :set number

  autocmd FocusGained * :set relativenumber
  autocmd BufEnter * :set relativenumber
  autocmd InsertLeave * :set relativenumber
else
  set relativenumber " Show relative numbers
endif

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  let powerline_exists = system("python -c 'import pkgutil; print(1 if pkgutil.find_loader(\"powerline\") else 0)'")

  if powerline_exists
    python3 from powerline.vim import setup as powerline_setup
    python3 powerline_setup()
    python3 del powerline_setup
    let g:Powerline_symbols = 'fancy'
    let base16colorspace=256
  else
    " Start the status line
    set statusline=%2*%-3.3n%0*\                 " buffer number
    set statusline+=%f\                          " file name
    set statusline+=%h%1*%m%r%w%0*               " flags
    set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
    set statusline+=%{&encoding},                " encoding
    set statusline+=%{&fileformat}]              " file format
    set statusline+=%=                           " right align
    set statusline+=Line:%l/%L[%p%%]\ \          " Line Number
    set statusline+=Col:%v\ \                    " Col Number
    set statusline+=Char:[%b][0x%B]              " current char
  endif
endif

""""""""""""""""""""""""""""""
" => Behaviors               "
""""""""""""""""""""""""""""""
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
set autoread    " Automatically reload changes if detected


""""""""""""""""""""""""""""""
" => Configuration vimscript files
"""""""""""""""""""""""""""""""
if isdirectory(expand("$HOME/.vim/configuration"))
  for f in split(glob('~/.vim/configuration/*.vim'), '\n')
    exe 'source' f
  endfor
endif

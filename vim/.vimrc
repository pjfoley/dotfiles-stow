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
    colorscheme chocolateliquor
    colorscheme jellybeans
  endif
catch /E185:/
  colorscheme default
endtry

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
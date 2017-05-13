if !has('nvim')
  set nocompatible " Set to be non-compatible to vi
endif

" Identify platforms {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent function! OSX()
  return has('macunix')
endfunction

silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
  return  (has('win16') || has('win32') || has('win64'))
endfunction

"}}}

" Vim directory path {{{
" """""""""""""""""""""""""""
let $VIMHOME=expand('<sfile>:p:h')
if WINDOWS()
    let $VIMHOME=expand('$VIMHOME/vimfiles')
    let $VIMCACHE=expand('$TMP/vim')
elseif OSX()
    let $VIMHOME=expand('$VIMHOME/.vim')
    let $VIMCACHE=expand('$HOME/tmp/vim')
else
    let $VIMHOME=expand('$VIMHOME/.vim')
    let $VIMCACHE=expand('$HOME/.cache/vim')
endif
"}}}

" Map leader to space bar
" Note: This line MUST come before any <leader> mappings
let mapleader = "\<space>"
let g:mapleader = "\<space>"

if filereadable(expand("$VIMHOME/configuration/@functions.vim"))
    source $VIMHOME/configuration/@functions.vim
endif

" Setup plug plugin {{{
" """"""""""""""""""""""""""
if filereadable(expand("$VIMHOME/plug.vim"))
  source $VIMHOME/plug.vim
endif
"}}}

" Backup/Swap/Persistence Settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has ('persistent_undo')
	try
			set undodir=$VIMCACHE . '/und')
			set undofile
			set undolevels=2000
			set undoreload=10000
	catch
			call MkDir($VIMCACHE . '/und')
	endtry
endif
try
    set backupdir=$VIMCACHE . '/bak')
    set backup
catch
		call MkDir($VIMCACHE . '/bak')
endtry

try
    set directory=$VIMCACHE . '/swp')
    set swapfile
catch
		call MkDir($VIMCACHE . '/swp')
endtry

try
	set directory=$VIMCACHE . '/viw')
	set swapfile
catch
	call MkDir($VIMCACHE . '/viw')
endtry
"}}}

" Colors and Scheme {{{
""""""""""""""""""""""""""
if !has('nvim')
  set t_Co=256
endif

let base16colorspace=256
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

" use a tags file (if any)
set tags=./tags;
"}}}

" VIM user interface {{{
"""""""""""""""""""""""""""""""""""""""""""""""

set ruler          " Always show the ruler
set number         " Line Numbers on
set wrap
set cmdheight=2    " Height of the command bar
set encoding=utf-8 " set utf-8 as standard encoding
set lazyredraw     " Don't redraw while executing macros (good performance config)
set cursorline
set cursorcolumn
set colorcolumn=81
"}}}

" line settings {{{
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
" }}}

" Behaviors {{{
""""""""""""""""""""""""""""""
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
set autoread    " Automatically reload changes if detected
set history=700
set autowrite

if has ("autocmd")
	filetype plugin indent on " Enable filetype plugins
endif

if has ("wildmenu") " Turn on the Wild menu
	set wildmenu

	set wildmode=longest,list

	" Ignore stuff
	set wildignore+=*.o,*.a
	set wildignore+=*~,*.pyc
	set wildignore+=*.swp,*.tmp

	" Disable image/video/audio files
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp,*.avi,*.mkv,*.mov,*.mp3

	" Disable output and VCS files
	set wildignore+=*.o,*.a,*.out,*.obj,.git,*.hg,*.rbc,*.rbo,*.class,.svn,*.gem

	" Disable compiled files
	set wildignore+=*.exe,*.pyc,*.elc

	" Disable archive files
	set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

	" Ignore bundler and sass cache
	set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*,
				\*.lock

	" Disable temp and backup files
	set wildignore+=*.tmp,*.swp,*~,._*,.DS_Store,*/.vim/und/*
endif
" }}}

" Text, tab and indent related {{{
"""""""""""""""""""""""""""""""""""""
set expandtab         " Use spaces instead of tabs
set smarttab          " Be smart when using tabs
set list              " Show invisible characters
set listchars=trail:. " Setup what characters to show
set shiftwidth=2
set softtabstop=2
set tabstop=2         " 1 tab == 2 spaces
set ffs=unix          " Use Unix as the standard file type

" Set indent options
set autoindent
set smartindent

set showmatch " Show matching brackets when text indicator is over them
set matchtime=2 " How long to show for in tenths of a second
"}}}

"  => Searching {{{
"""""""""""""""""""""""""""""""""""""""""""""""

set ignorecase " Ignore case when searching
set smartcase  " When searching try to be smart about cases
set incsearch  " Makes search act like search in modern browsers
set hlsearch   " Highlight search results
set magic      " Regular expressions
set so=5       " When searching for text centre the found line in the middle of the screen

set showmatch " Show matching brackets when text indicator is over them
set matchtime=2 " How long to show for in tenths of a second
"}}}

" Sounds {{{
"""""""""""""""""""""""""""""""""""""""""""""""
set noerrorbells
set visualbell
set t_vb=
" }}}

" Fix pasting into Terminal from System Clipboard {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""
if &term =~ "xterm.*" || &term =~ "rxvt.*"
	let &t_ti = &t_ti . "\e[?2004h"
	let &t_te = "\e[?2004l" . &t_te
	function XTermPasteBegin(ret)
		set pastetoggle=<Esc>[201~
		set paste
		return a:ret
	endfunction
	map <expr> <Esc>[200~ XTermPasteBegin("i")
	imap <expr> <Esc>[200~ XTermPasteBegin("")
	cmap <Esc>[200~ <nop>
	cmap <Esc>[201~ <nop>
endif
"}}}

" Source vimscript files {{{
"""""""""""""""""""""""""""""""
if isdirectory(expand("$HOME/.vim/configuration"))
  for f in split(glob('~/.vim/configuration/*.vim'), '\n')
    exe 'source' f
  endfor
endif
" }}}

" vim:foldmethod=marker:foldlevel=0 

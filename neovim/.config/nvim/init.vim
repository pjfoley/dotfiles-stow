exe 'source ' ~/.config/nvim/plugins.vim

" Map leader to space bar
" Note: This line MUST come before any <leader> mappings
let mapleader = "\<space>"
let g:mapleader = "\<space>"

for s:path in split(glob('~/.config/nvim/conf/*.vim'), "\n")
  exe 'source ' . s:path
endfor

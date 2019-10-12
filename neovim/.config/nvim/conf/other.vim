"##############################################################################
" Color-scheme :
"###############

let base16colorspace=256
set background=dark
try
  colorscheme base16-3024
catch
  colorscheme slate
endtry

" set termguicolors
" Disables color-scheme background color
hi Normal guibg=NONE

" Have italic comments
hi Comment cterm=italic gui=italic

"##############################################################################

"##############################################################################
" Auto-commands :
"################

" Delete trailing whitespaces on save
autocmd BufRead,BufNewFile * %s/\s\+$//e

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



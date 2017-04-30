" Tab creation/movement
map <leader>tc :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>td :tabclose<cr>
map <leader>tm :tabmove
map <leader>tn :tabnext<cr>
map <leader>tb :tabprevious<cr>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Go to last tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()"

" Spell check on/off
nmap <silent> <leader>sp :setlocal spell!<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" vim:foldmethod=marker:foldlevel=0

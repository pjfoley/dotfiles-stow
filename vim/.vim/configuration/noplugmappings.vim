" Fast saving
nmap <leader>w :w!<cr>

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

" Remove highlight when <cr> is pressed
nnoremap <leader><cr> :noh<cr><cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Handy file open shortcuts
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
map <leader>w= :wincmd =<cr>

" Map Y to act like D and C, i.e to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Reselect visual section after indent/outdent.
vnoremap < <gv
vnoremap > >gv

" Visually select the text that was last edited/pasted.
nnoremap gV `[v`]

" vim:foldmethod=marker:foldlevel=0

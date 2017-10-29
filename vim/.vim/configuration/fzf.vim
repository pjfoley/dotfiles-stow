if isdirectory(expand("$HOME/.fzf"))
  set rtp+=$HOME/.fzf
endif

nmap <Leader>fb  :Buffers<CR>
nmap <Leader>ff :Files<CR>
nmap <Leader>ft :Tags<CR>

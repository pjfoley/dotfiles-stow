" --------------------------------------------------------------------------------                 
" maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" purpose:      utility functions
" --------------------------------------------------------------------------------

" MkDir {{{
" --------------------------------------------------------------------------------
function! MkDir (dir)
	if !isdirectory(a:dir)
		if exists("*mkdir")
			call mkdir(a:dir, 'p')
			echo "Created directory: " . a:dir
		else
			echo "Please create directory: " . a:dir
		endif
	endif
endfunction
" }}}


" TabLine {{{
" --------------------------------------------------------------------------------
function! TabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    let tabnr = i + 1 " range() starts at 0
    let winnr = tabpagewinnr(tabnr)
    let buflist = tabpagebuflist(tabnr)
    let bufnr = buflist[winnr - 1]
    let bufname = fnamemodify(bufname(bufnr), ':t')

    let s .= '%' . tabnr . 'T'
    let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tabnr

    let n = tabpagewinnr(tabnr,'$')
    if n > 1 | let s .= ':' . n | endif

    let s .= empty(bufname) ? ' [No Name]' : ' ' . bufname

    let bufmodified = getbufvar(bufnr, "&mod")
    if bufmodified | let s .= '[+] ' | else | let s .= ' ' | endif
  endfor
  let s .= '%#TabLineFill#'
  return s
Endfunction
"}}}

" vim:foldmethod=marker:foldlevel=0 

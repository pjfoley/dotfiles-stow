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


" vim:foldmethod=marker:foldlevel=0 

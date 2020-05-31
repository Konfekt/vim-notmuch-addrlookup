if exists('g:loaded_notmuch') || &cp
  finish
endif
let g:loaded_notmuch = 1

let s:keepcpo         = &cpo
set cpo&vim
" ------------------------------------------------------------------------------

if !exists('g:notmuch_filetypes')
  let g:notmuch_filetypes = [ 'mail' ]
endif

let s:fts = ''
for ft in g:notmuch_filetypes
  let s:fts .= ft . ','
endfor
let s:fts = s:fts[:-1]

command! NotmuchCompletion call s:notmuch()

function! s:notmuch() abort
  call notmuch#SetupNotmuch()
  setlocal omnifunc=notmuch#complete
endfunction

augroup notmuch
  autocmd!
  exe 'autocmd FileType' s:fts 'NotmuchCompletion'
augroup end

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

function! notmuch#SetupNotmuch() abort
  " Setup g:notmuch_filter
  if !exists('g:notmuch_filter')
    let g:notmuch_filter = 0
  elseif g:notmuch_filter
    " Setup g:notmuch_filter_regex
    if !exists('g:notmuch_filter_regex')
      let g:notmuch_filter_regex = '\v^[[:alnum:]._%+-]*%([0-9]{9,}|([0-9]+[a-z]+){3,}|\+|not?([-_.])?reply|<(un)?subscribe>|<MAILER\-DAEMON>)[[:alnum:]._%+-]*\@'
    endif
  endif

  if !exists('s:notmuch_executable') 
    if executable('notmuch-addrlookup')
      let s:notmuch_executable = 1
    else
      echoerr 'No executable notmuch-addrlookup found.'
      echoerr 'Please install notmuch-addrlookup from https://github.com/aperezdc/notmuch-addrlookup-c!'
      let s:notmuch_executable = 0
    endif
  endif
endfunction

function! notmuch#complete(findstart, base) abort
  if a:findstart
    " locate the start of the word
    " we stop when we encounter space character
    let col = col('.')-1
    let text_before_cursor = getline('.')[0 : col - 1]
    " let start = match(text_before_cursor, '\v<([[:digit:][:lower:][:upper:]]+[._%+-@]?)+$')
    let start = match(text_before_cursor, '\v<\S+$')
    return start
  else
    let results = []
    if s:notmuch_executable
      silent let lines = split(system("notmuch-addrlookup " . " '" . a:base . "'"), '\n')
    endif

    if empty(lines)
      return []
    endif

    let results = []

    for line in lines
      if empty(line)
        continue
      endif

      let words = split(line, ' \ze<')

      if len(words) < 2
        continue
      endif

      let dict = {}
      " remove "
      let name = substitute(words[0], '\v^"|"$', '', 'g')
      let address = words[1]
      " remove < and >
      let address = substitute(address, '[<>]', '', 'g')

      " skip impersonal addresses
      if g:notmuch_filter && address =~? g:notmuch_filter_regex
        continue
      endif

      " normalize entries where name equals address
      if name =~# '^<.*>$'
        let name = address
      endif

      " add to completion menu
      let dict['word'] = name . ' <' . address . '>'
      let dict['abbr'] = strlen(name) < 35 ? name : name[0:30] . '...'
      let dict['menu'] = '<' . address . '>'

      call add(results, dict)
    endfor

    return uniq(results, 'i')
  endif
endfunction

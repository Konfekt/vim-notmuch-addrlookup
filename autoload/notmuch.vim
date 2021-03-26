function! notmuch#SetupNotmuch() abort
  " Setup g:notmuch_filter
  if !exists('g:notmuch_filter')
    let g:notmuch_filter = 0
  elseif g:notmuch_filter
    " Setup g:notmuch_filter_regex
    if !exists('g:notmuch_filter_regex')
      let g:notmuch_filter_regex = '\v^[[:alnum:]._%+-]*%([0-9]{9,}|([0-9]+[a-z]+){3,}|\+|nicht-?antworten|ne-?pas-?repondre|not?([-_.])?reply|<(un)?subscribe>|<MAILER\-DAEMON>)[[:alnum:]._%+-]*\@'
    endif
  endif

  if !exists('g:notmuch_command') 
    if executable('notmuch-addrlookup')
      let g:notmuch_command = 'notmuch-addrlookup'
    elseif executable('notmuch')
      let g:notmuch_command = 'notmuch address'
    else
      echoerr 'Neither notmuch-addrlookup nor notmuch was found executable.'
      echoerr 'Please install notmuch-addrlookup from https://github.com/aperezdc/notmuch-addrlookup-c or notmuch from https://notmuchmail.org!'
      let g:notmuch_command = ''
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
    if !empty(g:notmuch_command)
      silent let lines = split(system(g:notmuch_command . " '" . a:base . "'"), '\n')
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

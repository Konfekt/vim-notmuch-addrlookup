setlocal omnifunc=notmuch#complete
autocmd BufWinEnter <buffer> call notmuch#SetupNotmuch()


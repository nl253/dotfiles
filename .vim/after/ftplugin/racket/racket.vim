call opts#safe_setl([
            \ 'sw=2', 
            \ 'ts=4', 
            \ 'expandtab', 
            \ 'foldmethod=indent'
            \ ])
call opts#formatprg({'scmindent': 'scmindent'})
call opts#makeprg({'racket': 'racket %'})

" CtagsProject .git
CtagsLib! /usr/share/racket/collects/racket

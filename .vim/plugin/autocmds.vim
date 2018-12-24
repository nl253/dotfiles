exe 'let $AUTOCMDS = '.string(expand('<sfile>'))

exe 'setg statusline='.escape(' %-36.(%f #%n %q%r %w%m%) %=%-14.120(%(%<%{exists("b:git_status_summary") ? b:git_status_summary : ""} %{&tw} %{&wrap ? "wrap " : ""}%{&sw} %{&ts} %{&expandtab ? "expandtab " :""}%{&foldmethod == "marker" ? &foldmarker : &foldmethod}%) %(%y %3p%% of %L%)%)     ', ' :",|')

aug VariousAutoCmds
    au!

    au VimEnter                      bash-fc.*                  setf sh

    au BufWritePost,VimEnter,BufRead ~/*                        let b:git_status_summary = utils#git_status_summary()

    au FileType                      *                          call inits#all() | call templates#read_template()
    exe 'au FileType             '.join(g:markup_langs, ',').'  call inits#markup()'
    exe 'au FileType             '.join(g:prog_langs,   ',').'  call inits#programming()'
    au BufRead                       /{etc,usr,opt}/*           call inits#non_home()
    if has('nvim') 
        au TermOpen                  *                          call inits#term() 
    endif
    au FileType                      xml,html                   call inits#emmet()
    au FileType                      c{pp,},python,sh,rust,{java,type}script,json call inits#lang_server()
    " automatically change dir to the file you are editing
    au BufEnter                      ??*                        try | sil! lch %:p:h | cat /\vE(472|344|13)/ | endtry
    au BufRead,BufNewFile            *.{hbs,njk,jinja}          setf htmldjango
    au FileType                      html,htmldjango            if line("$") <= 1000 | syntax sync fromstart | endif

    " automatically reload external changes NOTE: doesn't always work properly
    au CursorHold,BufEnter           ~/*                        sil! checkt

    " autosave on focus lost
    au BufLeave,FocusLost            ??*                        try | up | cat /\vE(472|344|13)/ | endt

    au WinEnter                      ??*                        setl winwidth=20
    au CmdwinEnter                   *                          setl updatetime=2000
    au CmdwinLeave                   *                          setl updatetime=199

    " while grepping start from the project root
    au QuickFixCmdPre                vim,lv,gr,lgr              Root .git
    au QuickFixCmdPost               vim,lv,gr,lgr              try | sil! lch %:p:h | catch /\vE(472|344|13)/ | endtry

    " auto-display quickfix / location list window
    au QuickFixCmdPost               c{ex,adde},grep{,a}*       exe 'bo cw '.((len(getqflist()[:10]) < 8) ? len(getqflist()) + 1 : "")
    au QuickFixCmdPost               l{ex,gr,grepa,gete,ad}*    exe 'bo lw '.((len(getloclist(win_getid())[:10]) < 8) ? len(getloclist(win_getid())) + 1 : "")

    " au BufReadPost                   markdown                   if max(map(readfile(expand("%")), 'len(v:val)')) >= &textwidth | setl wrap | endif
    exe "au FileType ".join(g:markup_langs + ['gitcommit'], ',')." WordyWordy"
    " FIXME Doesn't seem to work
    " au BufReadPost,BufEnter          *.{txt,org,asciidoc,*wiki} if (empty(&ft) || &ft == 'text') && !empty(expand('%:t')) && filereadable(expand('%')) && (line("$") < 600) && (max(map(readfile(expand("%")), 'len(v:val)')) < 150) | setf markdown | endif

    " save each session before quitting
    " au VimLeavePre * SaveSession
aug END

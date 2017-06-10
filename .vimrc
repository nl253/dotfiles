
" VARIABLES and UTILS {{{
let g:MARKUP = [ 'markdown', 'vimwiki' ]

let g:MARKUP_EXT = ['md', 'wiki', 'rst']

let g:PROGRAMMING =  ['xhtml', 'html', 
            \'css', 'javascript', 
            \'python', 'php', 
            \'sh', 'zsh']

let g:REPL = ['php', 'python', 'sh', 'zsh', 'javascript']

let g:DICT_DIR = glob('~/.dicts/')

let g:TEMPLATE_DIR = glob('~/.templates/')

let g:SCRATCHPAD_DIR = glob('~/.scratchpads/')

" THESE NEED!!! TO BE RELATIVE TO $HOME
let g:WORKING_DIRS = ['Scripts', 'vimwiki', 'Projects', '.templates']

for d in [g:TEMPLATE_DIR, g:SCRATCHPAD_DIR, g:DICT_DIR]
    if empty(d)
        call system('!mkdir -p '.d)
    endif
endfor

let loaded_matchit = 1
let mapleader = " "
let maplocalleader = ","
" }}}

" VIM/NVIM INIT {{{
if has('nvim')
    let g:VIMDIR = glob('~/.config/nvim/')
    let g:PLUG_FILE = glob('~/.local/share/nvim/site/autoload/plug.vim')
    tnoremap <esc> <c-\><c-n>
else " if vim
    let g:VIMDIR = glob('~/.vim/')
    let g:PLUG_FILE = glob('~/.vim/autoload/plug.vim')
    let $MYVIMRC = glob('~/.vimrc')
    syntax enable
    filetype plugin indent on
endif

if empty(g:VIMDIR) | call system('!mkdir -p '.g:VIMDIR) | endif

if ! filereadable(g:PLUG_FILE) && executable('curl')
    call system('curl -flo ' . g:PLUG_FILE . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    PlugInstall
    source $MYVIMRC
endif
" }}}
"
" Plug init :: set variables {{{
execute 'set thesaurus=' . g:DICT_DIR . 'thesaurus.txt'
execute 'set dictionary=' .  g:DICT_DIR . 'frequent.dict'

if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged/')
else
    call plug#begin('~/.vim/plugged')
endif
" }}}

" OPTIONS {{{
let g:OPTIONS = [ 'ignorecase', 'smartcase', 'foldmethod=marker', 'autochdir',
            \'pumheight=12', 'sessionoptions+=resize',
            \'formatprg=fmt\ -s\ -u\ --width=79', 'spelllang=en_gb',
            \'completeopt=menuone,longest,noinsert', 'spellsuggest=best,12,', 'backupskip=*',
            \'complete=.,w,k,', 'mps+=<:>', 'nowritebackup', 'backupcopy=no',
            \'formatoptions=tcqjonl1', 'shiftwidth=4', 'autowrite', 'noswapfile',
            \'undofile', 'bufhidden=hide', 'sessionoptions-=options',
            \'clipboard=unnamed,unnamedplus', 'autoread', 'fileignorecase',
            \'hidden', 'splitbelow', 'sessionoptions-=blank',
            \'wildignore+=*cache*,*chrome*,*/.dropbox/*,*intellij*,*fonts*,*libreoffice*,',
            \'wildignore+=tags,*~,.vim,*sessio*,*swap*,*.git,*.class,*.svn,*.jpg,*.jpeg,',
            \'wildignore+=*.jpeg,.rope*,*.png,.rope*,', 'virtualedit=all',
            \'nostartofline', 'shortmess=ati', 'wildignorecase', 'noshowcmd',
            \'breakindent', 'undolevels=3000', 'path='.expand('~/').'.*',
            \'backspace=indent,eol,start', 'diffopt+=vertical,iwhite',
            \'mouse=', 'inccommand=nosplit',
            \'encoding=utf8', 'syntax=on', 'autoindent', 'nocompatible',
            \'magic', 'incsearch', 'ttyfast', 'hlsearch', 'wildmenu',
            \'display=lastline', 'nrformats=bin,hex', 'complete+=i',
            \'tagcase=ignore', 'switchbuf=useopen,newtab,', 'infercase']

for item in g:OPTIONS
    try
        execute 'silent set '.item
    catch /.*/
    endtry
endfor

for dir in g:WORKING_DIRS " so that :find is more powerful
    execute 'set path+=' . glob('~/') . dir . '/**,'
endfor
" }}}

" PLUGINS {{{ {{{
" place Plugins here
" -------------------
" GENERAL {{{
Plug 'tpope/vim-sleuth' | Plug 'tpope/vim-speeddating'
Plug 'tmux-plugins/vim-tmux-focus-events' " a must have if you work with tmux
Plug 'haron-prime/antares' | Plug 'tpope/vim-fugitive'
set statusline=%<%f\ %r\ %{fugitive#statusline()}%m\ %=%-14.(%q\ %w\ %y\ %p\ of\ %l%)\ \
Plug 'konfekt/fastfold' " more efficient folds
Plug 'scrooloose/nerdcommenter' | Plug 'wellle/targets.vim'
Plug 'tpope/vim-eunuch', {'on' : [ 'Move', 'Remove', 'Find', 
            \'Mkdir', 'Wall', 'SudoEdit', 'Chmod',
            \'SudoWrite', 'Unlink', 'Rename' ]}
" }}}

" COMPLETION {{{
if has('python') || has('python3')
    Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets'
    let g:ultisnipsexpandtrigger="<tab>"
    Plug 'maralla/completor.vim'
    let g:completor_blacklist = ['tagbar', 'qf', 'netrw', 'unite', 'vim']
    let g:completor_python_binary = 'python3.6'
endif

" }}}
"
" MARKUP {{{ {{{
Plug 'vimwiki/vimwiki'
let g:vimwiki_table_mappings = 0
let g:vimwiki_html_header_numbering = 2
let g:vimwiki_list_ignore_newline = 0
let g:vimwiki_hl_headers = 1

" markdown {{{
let g:markdown_fenced_languages = [
            \'html', 'python', 'zsh', 'javascript',
            \'php', 'css', 'java', 'vim', 'sh']

Plug 'mzlogin/vim-markdown-toc', {'for' : 'markdown'}
Plug 'rhysd/vim-gfm-syntax', {'for' : 'markdown'}
Plug 'nelstrom/vim-markdown-folding', {'for' : 'markdown'}
" }}}
Plug 'dkarter/bullets.vim' | Plug 'reedes/vim-textobj-sentence'

let g:bullets_enabled_file_types = ['markdown']

Plug 'dbmrq/vim-ditto', { 'on': [ 'ToggleDitto', 'DittoOn', 'DittoSent','DittoSentOn']}
Plug 'reedes/vim-wordy', { 'on': ['Wordy', 'WordyWordy'] }

" }}}
"
" table mode {{{
Plug 'dhruvasagar/vim-table-mode', { 'on': ['TableModeEnable'] }
let g:table_mode_disable_mappings = 1
let g:table_mode_verbose = 0 | let g:loaded_table_mode = 1
let g:table_mode_syntax = 1 | let g:table_mode_update_time = 800
au! BufEnter *.md let g:table_mode_corner = '|'
au! BufEnter *.rst let g:table_mode_corner_corner='+' | let g:table_mode_header_fillchar='='
" }}}

" }}}  }}}

" NETRW {{{
let g:netrw_scpport = "-P 22" | let g:netrw_sshport = "-p 22"
let g:netrw_preview = 1 | let g:netrw_mousemaps = 0
" }}}

" HASKELL {{{
"Plug 'shougo/vimproc.vim', {'do' : 'make', 'for' : ['haskell']}
"Plug 'eagletmt/ghcmod-vim', {'for' : 'haskell'}
"Plug 'eagletmt/neco-ghc', {'for' : 'haskell'}
"Plug 'itchyny/vim-haskell-indent', {'for' : 'haskell'}
"Plug 'Twinside/vim-haskellFold', {'for' : 'haskell'}
"let g:haskellmode_completion_ghc = 0   " disable haskell-vim omnifunc
"let hs_highlight_delimiters = 1
"let hs_highlight_boolean = 1 | let hs_highlight_more_types = 1
"let hs_highlight_types = 1 | let hs_highlight_debug = 1
" }}}
"
" PYTHON {{{
if has('python3') || has('python')
    "Plug 'davidhalter/jedi-vim', { 'for': 'python',  {{{
                "\'do': 'pip install jedi' }
    "let g:jedi#force_py_version = 3
    "let g:jedi#completions_enabled = 1
    "let g:jedi#goto_command = "<CR>"
    "let g:jedi#goto_assignments_command = "<leader>g"
    "let g:jedi#goto_definitions_command = "<LocalLeader>d"
    "let g:jedi#documentation_command = "K"
    "let g:jedi#usages_command = "<LocalLeader>u"
    "let g:jedi#rename_command = "<LocalLeader>r" }}}
    Plug 'klen/python-mode', { 'for': 'python' } 
    let g:pymode_python = 'python3'
    let g:pymode_quickfix_minheight = 4
    let g:pymode_breakpoint_bind = '<localleader>b'
    let g:pymode_lint_options_pep8 = { 'max_line_length': 150 }
    let g:pymode_lint_on_write = 0
    "let g:pymode_lint_ignore = "e303,w"
    let g:pymode_lint_checkers = ['pyflakes']
    let g:pymode_doc = 1 
    let g:pymode_lint = 1
    "let g:pymode_doc_bind = ''
    let g:pymode_paths = [glob('~/scripts/'), glob('~/projects/')]
    let g:pymode_rope_show_doc_bind = 'K' 
    let g:pymode_rope_completion = 1
    let g:pymode_rope_complete_on_dot = 0
    let g:pymode_rope_move_bind = '<LocalLeader>m'
    let g:pymode_rope_rename_bind = "<LocalLeader>r"
    let g:pymode_rope_rename_module_bind = "<LocalLeader>R"
    let g:pymode_rope_goto_definition_bind = '<C-p>'
    let g:pymode_rope_organize_imports_bind = '<LocalLeader>o'
    let g:pymode_rope_change_signature_bind = '<localleader>s'
    let g:pymode_rope_goto_definition_cmd = 'rightbelow vs'
    let g:pymode_rope_goto_definition_bind = '<localleader>d'
    let g:pymode_rope_autoimport = 1
    let g:pymode_rope_autoimport_modules = [
                \'os',
                \'re',
                \'typing',
                \'copy',
                \'pprint',
                \'operator',
                \'glob',
                \'itertools', 
                \'logging', 
                \'ctypes', 
                \'threading', 
                \'multiprocessing', 
                \'subprocess', 
                \'urllib.request', 
                \'sys', 
                \'pathlib']
    let g:pymode_rope_regenerate_on_write = 1
    let g:pymode_run_bind = '<leader>me'
    let g:pymode_breakpoint_cmd = 'import ipdb ; ipdb.set_trace()'
    let g:pymode_syntax_print_as_function = 1
    let g:pymode_lint_todo_symbol = 'do'
    let g:pymode_lint_comment_symbol = 'c'
    let g:pymode_lint_visual_symbol = 'v'
    let g:pymode_lint_error_symbol = 'e'
    let g:pymode_lint_info_symbol = 'i'
    let g:pymode_lint_pyflakes_symbol = 'f'
endif
" }}}

" SHELL {{{
let readline_has_bash = 1 | let g:is_bash = 1
let g:sh_fold_enabled = 4
" }}}

" WEB DEV {{{
"
" HTML {{{
Plug 'othree/html5.vim', { 'for': ['html', 'xhtml', 'php']}
Plug 'othree/html5-syntax.vim', { 'for': ['html', 'xhtml', 'php']}
Plug 'mattn/emmet-vim', { 'for': ['xml', 'html', 'xhtml', 'css', 'php' ]}
"let g:xml_syntax_folding = 1
let g:emmet_html5 = 1 | let g:html_hover_unfold = 1
let g:html_font = ["Sans Serif", "DejaVu Sans Mono", "Consolas", "monospace"]
let g:html_use_xhtml = 1 | let g:html_dynamic_folds = 1
let g:html_no_foldcolumn = 1 | let g:html_use_encoding = "UTF-8"
let html_wrong_comments=1
" }}}

" SQL {{{
let g:sql_type_default = 'mysql' | let msql_sql_query = 1
let g:ftPlugin_sql_omni_key = ',' " shadows localleader
Plug 'alcesleo/vim-uppercase-sql', {'for': 'sql'}
" }}}

" ZSH {{{
let g:zsh_fold_enable = 1
"}}}

" YAML {{{
let g:yaml_schema = 'pyyaml'
"}}}

" PHP{{{
Plug 'shawncplus/phpcomplete.vim', {'for': 'php'}
" }}} }}}
"
" FZF {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
" }}}

" FOR NVIM {{{
if has('nvim')
    Plug 'kassio/neoterm', {'on' : [
                \'TREPLSendSelection', 
                \'TREPLSendLine', 
                \'TREPLSendFile']}
    let g:neoterm_position = 'vertical'
    let g:neoterm_keep_term_open = 0
    let g:neoterm_size = 50
endif
" }}} }}}

call plug#end()

" Scratchpad {{{
function! Scratch()
    if index(['netrw', 'terminal','gitcommit', 'qf', 'gitcommit', 'git', 'netrc'], &filetype) >= 0  " blacklist
        return 1
    endif
    if &filetype == 'help'
        vnew ~/.scratchpads/scratch.vim
        setl ft=vim
    elseif &filetype == 'man'
        vnew ~/.scratchpads/scratch.sh
        setl ft=sh
    elseif (index(g:MARKUP, &filetype) >= 0) && expand('%:r') != expand('%:e') && len(expand('%:e')) > 0 
        if expand('%:p') != '~/vimwiki/diary/diary.wiki'
            vnew ~/vimwiki/diary/diary.wiki
            setl ft=vimwiki
        else
            return 0
        endif
    elseif (index(g:PROGRAMMING, &filetype) >= 0) && expand('%:r') != expand('%:e') && len(expand('%:e')) > 0 
        vnew ~/.scratchpads/scratch.%:e
        execute 'setl ft='.&filetype
    else
        vnew ~/.scratchpads/scratch
        setl ft=scratch
    endif
    vertical resize 60
    write
    nnoremap <buffer> <BS> :close!<CR>
    nnoremap <buffer> q :close!<CR>
    vnoremap <buffer> <BS> <Nop>
endfunction
command! Scratch call Scratch()
" Alt-BackSpace in normal mode to quickly open a scratch buffer with the same
nnoremap <BS> :silent Scratch<CR>
vnoremap <BS> :yank<CR>:Scratch<CR>p
" }}}

" INIT  {{{
" Init() execute for all buffers on filetype {{{
"
function! Markup()
    set complete=.,w, conceallevel=3 makeprg=write-good 
    setl spell formatoptions=tcrqjonl1 foldlevel=1 sw=4 textwidth=79 
    setl formatprg=fmt\ -s\ -u\ --width=79
    if &filetype == 'vimwiki'
        nnoremap <buffer> <Leader>x :VimwikiToggleListItem<CR>
    else
        nnoremap <buffer> <Leader>x :ToggleCheckbox<CR>
    endif
    " SLOW! {{{
    "execute 'set complete+=k'.glob('~/vimwiki').'/*/*/*.wiki'
    "execute 'set complete+=k'.glob('~/vimwiki').'/*/*.wiki'
    "execute 'set complete+=k'.glob('~/vimwiki').'/*.wiki' }}}
    "set complete+=k*.wiki
    "set complete+=k*.md
    "set complete+=k*.rst
    for f in split(glob('*.wiki'))
        execute 'set complete+=k./'.f
    endfor
    for f in split(glob('*.rst'))
        execute 'set complete+=k./'.f
    endfor
    for f in split(glob('*.md'))
        execute 'set complete+=k./'.f
    endfor
    nnoremap <buffer> <Leader>mS :silent setl spell<CR>:WordyWordy<CR>:Neomake<CR>:DittoSentOn<CR>
    nnoremap <expr> <buffer> <M-Tab> exists('b:table_mode_on') && b:table_mode_on == 1 ? ":TableModeRealign\<CR>" : "\<M-Tab>"
    if executable('wn')
        nnoremap <buffer> K :execute 'Capture wn ' . expand('<cword>') . ' -over'<CR>
    endif
endfunction

function! Programming()
    setl nospell 
    set complete=.,w,t 
    if expand('%:e') != ''     " if there is an extension (needed)
        for i in split(glob("*.".expand('%:e')))
            execute 'setl complete+=k'.i
        endfor
        " SLOW! {{{
        "execute 'set complete+=k'.glob('~/Projects').'/*/*.'.expand('%:e').","
        "execute 'set complete+=k'.glob('~/Scripts').'/*/*.'.expand('%:e').","
        "execute 'set complete+=k'.glob('~/Scripts').'/*/*.'.expand('%:e')."," "}}}
    endif
endfunction

function! Init()
    if exists("+omnifunc") && &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif
    if exists("+completefunc") && &completefunc == ""
        setlocal completefunc=syntaxcomplete#Complete
    endif
    if filereadable(g:DICT_DIR . &filetype . '.dict')
        execute 'setl dictionary='. g:DICT_DIR . &filetype . '.dict'
        set complete+=k,
    endif
endfunction
" }}}

" GitcommitInit() {{{
function! GitcommitInit()
    setl virtualedit=block
    set complete=.,kspell,
    setl spell 
endfunction
" }}}
"
" ManInit() {{{
function! ManInit()
    nnoremap <buffer> <CR> :execute 'Man ' . expand('<cword>')<CR>
    " make it more like less
    nnoremap <buffer> q :bd!<CR>
    nnoremap <buffer> d <C-d>
    nnoremap <buffer> u <C-u>
    nnoremap <buffer> <M-j> /\v\w+\(\d+\)<CR>
    nnoremap <buffer> <M-k> ?\v\w+\(\d+\)<CR>
    nnoremap <buffer> ] /\v^[A-Z]{3,}\n<CR>
    nnoremap <buffer> [ ?\v^[A-Z]{3,}\n<CR>
    setl nowrap
endfunction
" }}}

" ShInit() {{{
function! ShInit()
    nnoremap <buffer> <CR> :execute 'Man ' . expand('<cword>')<CR>
    set complete+=k~/.bashrc,k~/.shells/**.sh,k~/.profile,k~/.bash_profile,k~/.bash/**
    set complete+=k~/Scripts/*.sh
    if executable('shfmt')
        setl formatprg=shfmt
    endif
endfunction
" }}}

" PhpInit() {{{
function! PhpInit()
    nnoremap <buffer> <Leader>me :!php % > /tmp/php-converted.html<CR>:!google-chrome-stable /tmp/php-converted.html<CR>
    if executable('js-beautify')
        setl formatprg=js-beautify\ --type\ html
    endif
endfunction
" }}}

" HelpInit() {{{
function! HelpInit()
    " on enter follow that `tag`
    nnoremap <buffer> <CR> <C-]>
    nnoremap <buffer> K <C-]>
    " make it more like less
    nnoremap <buffer> q :bd!<CR>
    nnoremap <buffer> d <C-d>
    nnoremap <buffer> u <C-u>
endfunction
" }}}

" HaskellInit() {{{
"function! HaskellInit()
    "if ! executable('stack')
        "!curl -sSL https://get.haskellstack.org/ \| sh
    "endif
    "if ! executable('stylish-haskell')
        "!stack install stylish-haskell
    "endif
    "setl omnifunc=necoghc#omnifunc foldmethod=expr
    "setl formatprg=stylish-haskell
    "if has('nvim') | nnoremap <buffer> <M-CR> :TREPLSendLine<CR> | endif
    "nnoremap <buffer> <Leader>me :!ghc %:p<CR>:lexpr system(expand('%:p:r'))<CR>:lopen 5<CR>
    "nnoremap <buffer> K :GhcModInfo<CR>
"endfunction
" }}}

" QfInit() {{{
function! QfInit()
    " easir preview after grepping (use emacs' C-p C-n)
    nnoremap <buffer> <C-n> j<CR><C-w><C-w>
    nnoremap <buffer> <C-p> k<CR><C-w><C-w>
    " quick exit
    nnoremap <buffer> q :cclose<CR>:lclose<CR>
    setl nospell
endfunction
" }}}

" VimInit() {{{
function! VimInit()
    nnoremap <buffer> K :execute 'help ' . expand('<cword>')<CR>
    setl foldmethod=marker
    set complete=.,w,
    inoremap <C-n> <C-x><C-v>
    if expand('%:t') != 'init.vim' && expand('%:t') != '.vimrc'
        if has('nvim')
            set complete+=k~/.config/nvim/init.vim,
        else
            set complete+=k~/.vimrc,
        endif
    endif
endfunction
" }}}

" VimWikiInit() {{{
function! VimWikiInit()
    nmap <F13> <Plug>VimwikiNextLink
    nmap <F14> <Plug>VimwikiPrevLink
    nmap <F15> <Plug>VimwikiAddHeaderLevel
    nnoremap <buffer> <Leader>me :Vimwiki2HTMLBrowse<CR>
    setl comments+=:::
endfunction
" }}}

" MarkdownInit() {{{
function! MarkdownInit()
    if executable('markdown-preview')
        nnoremap <buffer> <Leader>me :!markdown-preview %<CR>
    endif
    syn region markdownBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart
    syn region markdownBold start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend contains=markdownLineStart
    syn region markdownBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart
    syn region markdownBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart
endfunction
" }}}

" PythonInit() {{{
function! PythonInit()
    nnoremap <buffer> <Leader>mS :PymodeLint<CR>
    if executable('autopep8') && executable('pycodestyle')
        setl formatprg=autopep8\ -
    endif
    setl complete-=k formatoptions=cqjonl1 
    nnoremap <buffer> q :pclose<CR>q
    nnoremap <buffer> <LocalLeader>eM :call pymode#rope#extract_method()<CR>
    nnoremap <buffer> <localleader>f :call pymode#rope#find_it()<CR>
    nnoremap <buffer> <LocalLeader>ev :call pymode#rope#extract_variable()<CR>
    nnoremap <buffer> <localleader>C :call pymode#rope#generate_class()<CR>
    nnoremap <buffer> <localleader>F :call pymode#rope#generate_function()<CR>
    nnoremap <buffer> <localleader>P :call pymode#rope#generate_package()<CR>
    nnoremap <buffer> <CR> :call pymode#rope#goto_definition()<CR>
endfunction
" }}}
"
" JavascriptInit() {{{
function! JavascriptInit()
    setl foldmethod=marker
    setl foldmarker={,}
    if executable('js-beautify')
        setl formatprg=js-beautify
    endif
endfunction
" }}}
"
" CssInit() {{{
function! CssInit()
    setl foldmethod=marker
    setl foldmarker={,}
    if executable('js-beautify')
        setl formatprg=js-beautify\ --type\ css
    endif
endfunction
" }}}
"
" HTMLInit() {{{
function! HTMLInit()
    nnoremap <buffer> <Leader>me :!$BROWSER %:p<CR>
    setl foldmethod=indent
    if executable('js-beautify')
        setl formatprg=js-beautify\ --type\ html
    endif
endfunction
"}}} "}}}

" Template {{{
function! Expand() 
    write
py3 << EOF
import os
import platform
import string
import sys
import time
import vim

variables = {
    'AUTHORS': "",
    'CPU_COUNT': os.cpu_count(),
    'DATE': time.strftime("%c"),
    'JAVA_VERSION': str(platform.java_ver()),
    'MONTH': time.strftime("%B"),
    'PLATFORM': platform.platform(),
    'PYTHON_COMPILER': platform.python_compiler(),
    'PYTHON_IMPLEMENTATION': platform.python_implementation(),
    'PYTHON_VERSION': platform.python_version(),
    'SYSTEM': platform.system(),
    'TIME': time.strftime("%H:%M"),
    'PROJECT_NAME': "",
    'PROJECT_LANGUAGE': "1.0",
    'PROJECT_TAGS': "",
    'PROJECT_VERSION': "" }

with open(vim.current.buffer.name, mode="r", encoding="utf-8") as f:
    text = f.read() 
    f.close()
 
with open(vim.current.buffer.name, mode="w", encoding="utf-8") as f:
    f.write(string.Template(text).safe_substitute(variables))
    f.close()
EOF
checktime
write
endfunction

command! ExpandVars call Expand()

function! Template()
    if filereadable(g:TEMPLATE_DIR."template.".expand("%:e"))
        normal gg
        execute 'read '.g:TEMPLATE_DIR."template.".expand("%:e")
        normal gg
        normal dd
        ExpandVars
    endif
endfunction
command! Template call Template()
"}}}

" CTags() {{{
function! Ctags()
    if expand('%') == ''
        return 0
    endif
    let s:working_dirs = g:WORKING_DIRS
    for i in range(len(s:working_dirs))
        let s:working_dirs[i] = s:working_dirs[i].'/**.'.expand('%:e')
    endfor
    let s:working_dirs = join(s:working_dirs)
    call system('ctags -R '.s:working_dirs.' **.'.expand('%:e'))
endfunction
" }}}

" AUTOCOMMANDS {{{
aug VIMENTER
    " go back to where you left off
    au!
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " automatically change dir to the file you are editing
    au BufEnter * try | lchdir %:p:h | catch /.*/ | endtry
    " automatically reload external changes NOTE: doesn't always work properly
    au CursorHold  * silent!  checktime
    " by default blank files are markdown notes
    au VimEnter * if &filetype == "" | setl ft=markdown | endif
    au FocusLost   * silent!  wall
    au CmdwinEnter * setlocal updatetime=2000
    au CmdwinLeave * setlocal updatetime=200
    au BufNewFile * call Template()
    au FileType * call Init()
    execute 'au! FileType '.join(g:PROGRAMMING, ',').' call Programming()' 
    execute 'au! FileType '.join(g:MARKUP, ',').' call Markup()'
    au FileType man call ManInit()
    au FileType sh call ShInit()
    au FileType vim call VimInit()
    au FileType help call HelpInit()
    au FileType xhtml,html,xml call HTMLInit()
    au FileType gitcommit call GitcommitInit()
    au FileType vimwiki call VimWikiInit()
    au FileType qf call QfInit()
    au FileType python call PythonInit()
    au FileType javascript,json call JavascriptInit()
    au FileType css call CssInit()
    au FileType php call PhpInit()
    au FileType markdown call MarkdownInit()
    au BufNewFile,BufRead *.txt setl ft=asciidoc
    au BufNewFile call Ctags()
    "au FileType haskell call HaskellInit()
aug END
" }}}

" download dictionaries from GitHub if missing {{{
let g:DICTS = ['frequent.dict', 'haskell.dict' , 'thesaurus.txt', 'php.dict', 'css.dict', 'sql.dict', 'sh.dict', 'javascript.dict']
" let g:DICTS += ['erlang.dict', 'php.dict', 'haskell.dict', 'perl.dict', 'java.dict'] " UNCOMMENT IN NEED
for dict in g:DICTS
    if ! filereadable(g:DICT_DIR . dict) && executable('curl')
        execute '!curl -fLo ' . g:DICT_DIR . dict . ' https://raw.githubusercontent.com/nl253/Dictionaries/master/' . dict
    endif
endfor
" }}}

colorscheme antares

" COMMANDS {{{
" markup conversion, recommended {{{
if executable('pandoc')
    command! TOmarkdown call system('pandoc -s -o '.expand('%:p:r').'.md -t markdown_github --atx-headers --ascii --toc '.expand('%:p')) | sleep 250ms | vs %:p:r.md
    command! TOrst call system('pandoc -s -o '.expand('%:p:r').'.rst -t rst --ascii '.expand('%:p')) | sleep 250ms | vs %:p:r.rst
    command! TOtex call system('pandoc -s -o '.expand('%:p:r').'.tex  -t tex '.expand('%:p')) | sleep 250ms | vs %:p:r.tex
    command! TOwordocx call system('pandoc -s -o '.expand('%:p:r').'.docx -t docx '.expand('%:p')) | sleep 250ms | vs %:p:r.docx
    command! TOhtml2 call system('pandoc -s -o '.expand('%:p:r').'html -t html --html-q-tags --self-contained '.expand('%:p')) | sleep 250ms | vs %:p:r.html
    command! TOmediawiki call system('pandoc -s -o '.expand('%:p:r').'wiki -t mediawiki --self-contained '.expand('%:p')) | sleep 250ms | vs %:p:r.wiki

    function! DocxTOmd()
        !pandoc -f docx -t markdown_github %:p -o /tmp/%:r.md
        edit /tmp/%:r.md
    endfunction

    au! BufRead *.docx call DocxTOmd()
endif
if executable('pdftotext')
    function! PdfTOtxt()
        !pdftotext -eol unix %:p /tmp/%:r.txt
        edit /tmp/%:r.txt
    endfunction
    command! PdfTOtxt call PdfTOtxt()
    function! PdfInit()
        if matchstr(expand('%'),' ') == ""
            PdfTOtxt
        endif
    endfunction
    au! FileType pdf call PdfInit()
endif
" }}}
if executable('dos2unix')
    command! Dos2Unix !dos2unix %:p | edit
endif
command! CountOccurances execute printf('%%s/%s//gn', escape(expand('<cword>'), '/')) | normal! ``
command! -bang -nargs=* GGrep call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)
command! -complete=shellcmd -nargs=+ Capture lexpr(system(expand(<q-args>))) | topleft lopen
command! Evax %!evax 
" }}}

" KEYBINDINGS {{{
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap <expr> <Leader>mS &filetype != 'python' ? ":Neomake\<CR>" : ":PymodeLint\<CR>"

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
noremap k gk
noremap j gj

nnoremap <expr> <M-CR> index(g:REPL, &filetype) >= 0 && has('nvim') ? ":TREPLSendLine\<CR>" : "\<M-CR>"
vnoremap <expr> <M-CR> index(g:REPL, &filetype) >= 0 && has('nvim') ? ":TREPLSendSelection\<CR>" : "\<M-CR>"

"automatically enable spell if you attempt to use correction
nnoremap <expr> z= &spell ? "z=" : ":setl spell\<CR>z="
nnoremap <expr> [s &spell ? "[s" : ":setl spell\<CR>[s"
nnoremap <expr> ]s &spell ? "]s" : ":setl spell\<CR>]s"

"move visually highlighted lines
"vnoremap > >gv
"vnoremap < <gv

nnoremap <Leader>fed    :e $MYVIMRC<CR>
nnoremap <Leader>fer    :so $MYVIMRC<CR>
nnoremap <Leader>ga     :Git add %:p<Space>
nnoremap <Leader>gB     :Gblame<CR>
nnoremap <Leader>gd     :Gdiff<Space>
nnoremap <Leader>gC     :Gcommit<CR>
nnoremap <Leader>gs     :Gstatus<CR>
nnoremap <Leader>gW     :Gwrite<Space>
nnoremap <Leader>gD     :Gdiff<CR>
nnoremap <Leader>gm     :Gmove<Space>
if len($TMUX) > 1
    nnoremap <Leader>gp     :Gpush<CR>
endif

inoremap <C-w> <C-o>dB
inoremap <C-u> <C-o>d0
"nnoremap <M-k> :silent lprev<CR>
"nnoremap <M-j> :silent lnext<CR>
nnoremap <LocalLeader>* :lgrep <cword> %:p<CR>:lopen<CR>
nnoremap <Leader>* :execute 'grep '.expand('<cword>').' '.substitute(&path,',',' ','g')<CR>
nnoremap <C-k> :silent cn<CR>
nnoremap <C-j> :silent cp<CR>
nnoremap <Leader>a :Ag!<CR>
nnoremap <Leader>g<Leader> :GGrep!<CR>
nnoremap <Leader>l<Leader> :Lines!<CR>
nnoremap <Leader>t<Leader> :Tags!<CR>
nnoremap <Leader>/ :History/<CR>
nnoremap <Leader>: :History:<CR>
nnoremap <Leader><Leader> :Commands!<CR>

" intellij
nnoremap <Leader>f<Leader> :Files! .<CR>
nnoremap <Leader>m<Leader> :Marks!<CR>

"cno w!!<CR> %!sudo tee > /dev/null %<CR>
" vim: foldlevel=1 nospell


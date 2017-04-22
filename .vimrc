
let g:MARKUP = [ 'markdown', 'org']
let g:PROGRAMMING =  [ 'vim', 'xhtml', 'html', 'css', 'javascript', 'python', 'php', 'sh', 'zsh' ]
let g:REPL = ['php', 'python', 'sh', 'zsh', 'javascript']

let loaded_matchit = 1
let mapleader = " "
let maplocalleader = ","

" OPTIONS {{{
set ignorecase smartcase foldmethod=marker autochdir sessionoptions-=blank completeopt=menuone,longest,preview,noinsert diffopt=filler,vertical,iwhite
set mouse= complete=.,w,t noswapfile mps+=<:> bufhidden=hide wildignorecase shiftwidth=4 autowrite undofile fileignorecase hidden clipboard=unnamed,unnamedplus
set wildignore+=*cache*,*chrome*,*/.dropbox/*,*intellij*,*fonts*,*libreoffice*,*.png,*.jpg,*.jpeg,tags,*~,.vim,*sessio*,*swap*,*.git,*.class,*.svn
set nostartofline " Don't reset cursor to start of line when moving around
set splitbelow " New window goes below
set virtualedit=all 
set shortmess=atI " Don't show the intro message when starting vim
set path=
execute 'set path+=' . glob('~') . '/*'
execute 'set path+=' . glob('~') . '/Scripts/'
execute 'set path+=' . glob('~') . '/Notes/*'
execute 'set path+=' . glob('~') . '/PyComLine/'
execute 'set path+=' . glob('~') . '/OneDrive/'
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(line\ %l%)\ %P\ 
" }}}

" DOWNLOAD PLUG {{{
if has('nvim') && ! filereadable(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    source ~/.config/nvim/init.vim
    PlugInstall
elseif ! has('nvim') && ! filereadable(glob('~/.vim/autoload/plug.vim'))
    !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    source ~/.vimrc
    PlugInstall
endif
" }}}

" PLUG INIT :: SET VARIABLES {{{
if has('nvim')
    let g:VIMDIR = glob('~/.config/nvim/')
    let g:DICTDIR = glob('~/.config/nvim/dicts/')
    tnoremap <Esc> <C-\><C-n>
    if empty(g:DICTDIR)
        !mkdir -p ~/.config/nvim/dicts
    endif
    call plug#begin('~/.local/share/nvim/plugged/')
else
    let $MYVIMRC = glob('~/.vimrc')
    call plug#begin('~/.vim/plugged')
    let g:VIMDIR = glob('~/.vim/')
    let g:DICTDIR = glob('~/.vim/dicts/')
    if empty(g:DICTDIR)
        !mkdir -p ~/.vim/dicts
    endif
    syntax enable
    filetype plugin indent on
    set encoding=utf8 syntax=on autoindent nocompatible magic incsearch ttyfast
    set display=lastline formatoptions=tcqj nrformats=bin,hex complete+=i hlsearch
    if has('tags')
        set tags
    endif
endif
" }}}

" Place plugins here

Plug 'Haron-Prime/Antares'
Plug 'tpope/vim-dispatch', {'on' : ['Make','Dispatch','Copen','Start','Spawn']}
Plug 'tpope/vim-sleuth' " auto set buffer options
" Plug 'tpope/vim-projectionist'

" SESSION {{{
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session' " enhanced session management
let g:session_autosave = 'yes'
let g:session_autosave_to = 'default'
let g:session_autosave_periodic = 3
let g:session_lock_enabled = 0
let g:session_autoload = 'yes'
let g:session_default_to_last = 1
let g:session_persist_globals = [ '&foldmethod', '&foldcolumn', '&scrolloff', '&spell', '&wrap',
            \'&scrollbind', '&number', '&relativenumber', '&foldmarker', '&background']

if has('nvim') | let g:session_directory = '~/.config/nvim/session'| else | let g:session_directory = '~/.vim/session' | endif

" }}}

Plug 'vim-scripts/bats.vim', {'for' : 'sh'}
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'junegunn/vim-easy-align', { 'on' : 'EasyAlign' }
Plug 'Konfekt/FastFold' " more efficient folds
Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-eunuch', {'on' : [ 'Move', 'Remove', 'Find', 'Mkdir', 'Wall',
            \'SudoWrite', 'SudoEdit', 'Unlink', 'Chmod', 'Rename', ]}

" SQL {{{
let g:sql_type_default = 'mysql'
let g:ftplugin_sql_omni_key = ',' " shadows localleader
" }}}
"
" SHELL {{{
let readline_has_bash = 1
let g:is_bash	   = 1
let g:sh_fold_enabled= 4 
" }}}

Plug 'reedes/vim-wordy', { 'on': ['Wordy', 'WordyWordy']}
Plug 'reedes/vim-textobj-sentence'
Plug 'neomake/neomake', {'on' : [ 'Neomake', 'NeomakeProject', 'NeomakeFile' ]}
let g:neomake_markdown_enabled_makers = ['writegood', 'proselint']

" SYNTASTIC {{{ 
Plug 'vim-syntastic/syntastic', { 'on' : [ 'SyntasticInfo', 'SyntasticCheck', 'SyntasticToggleMode']}
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_enable_signs = 1
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': [] }
let g:syntastic_vim_checkers = []
let g:syntastic_html_checkers = ['w3', 'validator', 'tidy', 'jshint', 'eslint']
let g:syntastic_xhtml_checkers = ['w3', 'validator', 'tidy', 'jshint', 'eslint']
let g:syntastic_markdown_checkers = ['proselint', 'mdl', 'textlint']
let g:syntastic_python_checkers = ['flake8', 'pylint', 'pycodestyle']
let g:syntastic_sh_checkers = ['bashate', 'sh', 'shellcheck']
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
"let g:syntastic_css_checkers = []
" }}}

Plug 'dbmrq/vim-ditto', { 'on': [ 'ToggleDitto', 'DittoOn', 'DittoSent',
            \'DittoSentOn', 'DittoFile', 'DittoFileOn', 'DittoPar', 'DittoParOn'],
            \'for' : g:MARKUP}

Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' , 'do' : 'npm install -g writegood proselint'}

Plug 'xolox/vim-easytags', {'for' : g:PROGRAMMING}
let b:easytags_auto_highlight = 1
let g:easytags_events = ['BufReadPost']
let g:easytags_always_enabled = 1
let g:easytags_resolve_links = 1

" TABLE MODE {{{
Plug 'dhruvasagar/vim-table-mode', { 'for':  
            \['mardown', 'org'], 
            \'on': ['TableModeEnable'] }
let g:table_mode_disable_mappings = 1
let g:table_mode_verbose = 0 " stops from indicating that it has loaded
let g:table_mode_syntax = 1
let g:table_mode_update_time = 800
" }}}

Plug 'jceb/vim-orgmode', {'for' : 'org'}
let g:org_todo_keywords = ['TODO', '|', 'DONE', 'PENDING',
            \ 'URGENT', 'SOON', 'WAITING', 'IN_PROGRESS']
let g:org_heading_shade_leading_stars = 0

" Markdown
" ==========
"
Plug 'blindFS/vim-taskwarrior', {'on' : 'TW'}

" MARKDOWN {{{
Plug 'godlygeek/tabular', { 'for': ['markdown'], 'on' : 'Tabularize' }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown']}
let g:vim_markdown_autowrite = 1
let g:vim_markdown_emphasis_multiline = 1
let g:vim_markdown_new_list_item_indent = 4
let g:vim_markdown_fenced_languages = [
            \'sh=shell', 'java', 'python=py',
            \'html=xhtml', 'css', 'php',
            \'javascript=js']

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_folding_level = 1
" }}}

" PYTHON {{{
Plug 'klen/python-mode', { 'for': 'python' }

let g:pymode_breakpoint_bind = '<localleader>b'
let g:pymode_doc = 1
let g:pymode_doc_bind = '<C-q><C-q>'
let g:pymode_indent = 1
let g:pymode_lint = 0 " Neomake is better
let g:pymode_motion = 1
let g:pymode_options = 1
let g:pymode_options_colorcolumn = 1
let g:pymode_paths = [glob('~/Scripts/')]
let g:pymode_python = 'python3'
let g:pymode_rope = 1
let g:pymode_rope_autoimport = 1
let g:pymode_rope_autoimport_import_after_complete = 1
let g:pymode_rope_change_signature_bind = '<localleader>cs'
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_extract_method_bind = '<localleader>em'
let g:pymode_rope_extract_variable_bind = '<localleader>ev'
let g:pymode_rope_goto_definition_bind = '<C-e><C-e>'
let g:pymode_rope_module_to_package_bind = '<localleade>rmp'
let g:pymode_rope_move_bind = '<localleader>mm'
let g:pymode_rope_organize_imports_bind = '<localleader>i'
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_rename_bind = '<localleader>rr'
let g:pymode_rope_rename_module_bind = '<localleader>rm'
let g:pymode_rope_show_doc_bind = '<localleader>d'
let g:pymode_rope_use_function_bind = '<localleader>uf'
let g:pymode_run_bind = '<leader>me'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_print_as_function = 1
let g:pymode_trim_whitespaces = 1
" }}}

" COMPLETION {{{
if ((has('python') || has('python3')) && has('lambda') && has('timers') && has('job')) || has('nvim')
    Plug 'maralla/completor.vim'
    if filereadable(glob('~/.pyenv/versions/3.5.0/bin/python3.5'))
        let g:completor_python_binary = glob('~/.pyenv/versions/3.5.0/bin/python3.5')
    else
        let g:completor_python_binary = '/usr/bin/python'
    endif
    let g:completor_completion_delay = 1
endif

if has('python') || has('python3')
    Plug 'SirVer/ultisnips' " Track the engine.
    Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsEditSplit="vertical"
endif
" }}}

Plug 'othree/html5.vim', { 'for': ['html', 'xhtml']}
Plug 'othree/html5-syntax.vim'
Plug 'mattn/emmet-vim', { 'for': ['xml', 'html', 'xhtml', 'css' ]}

Plug 'chrisbra/Colorizer', { 'for': [
            \ 'css', 'html', 'javascript', 'json',
            \ 'org', 'markdown', 'xhtml', 'yaml']}

let g:emmet_html5 = 1

Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }

Plug 'maksimr/vim-jsbeautify', { 'for': [ 'javascript', 'json', 'html',
            \'xhtml', 'xml', 'css'] }

Plug 'wellle/targets.vim'


" FOR NVIM {{{
if has('nvim')
    Plug 'kassio/neoterm', {'on' : ['TREPLSendSelection', 'TREPSendLine', 'TREPLSendFile']}
    nnoremap <expr> <M-CR> index(g:REPL, &filetype) >= 0 ? ":TREPLSendLine\<CR>" : "\<M-CR>"
    vnoremap <expr> <M-CR> index(g:REPL, &filetype) >= 0 ? ":TREPLSendSelection\<CR>" : "\<M-CR>"
    let g:neoterm_position = 'vertical'
    let g:neoterm_keep_term_open = 0
    let g:neoterm_size = 50
    Plug 'sbdchd/neoformat', {'on' : 'Neoformat'}
    if executable('ranger') | Plug 'airodactyl/neovim-ranger' | endif
endif
" }}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()

" SCRATCHPAD {{{
function! Scratch()
    if index(['netrw', 'terminal','gitcommit'], &filetype) >= 0  " blacklist
        return 1
    endif
    if index(g:PROGRAMMING, &filetype) >= 0 && expand('%:r') != expand('%:e') && len(expand('%:e')) > 0
        execute 'vnew ' . '~/Notes/scratch.' . expand('%:e')
        execute 'setl ft=' . &filetype
    elseif index(g:MARKUP, &filetype) >= 0
        vnew ~/Notes/scratch
        setl ft=note
    elseif &filetype == 'help'
        vnew ~/Notes/scratch.vim
        setl ft=vim
    elseif &filetype == 'man'
        vnew ~/Notes/scratch.sh
        setl ft=sh
    else
        vnew ~/Notes/scratch
        setl ft=note
    endif
    vertical resize 60
    write
    nnoremap <buffer> <M-BS> :close!<CR>
    nnoremap <buffer> q :close!<CR>
    vnoremap <buffer> <M-BS> <Nop>
endfunction
command! Scratch call Scratch()
" Alt-BackSpace in normal mode to quickly open a scratch buffer with the same
" filetype. It will be saved in ~/Notes/scratch{.py,.java,.go} etc
nnoremap <M-BS> :Scratch<CR>
vnoremap <M-BS> :yank<CR>:Scratch<CR>p
nnoremap <Leader><BS> :edit ~/Notes/todo.org<CR>`` 
" }}}

"Init() {{{
function! Init()
    if index(g:MARKUP, &filetype) < 0 
        setlocal nospell 
    elseif index(g:MARKUP, &filetype) >= 0 
        setlocal spell 
        if ! exists('b:table_mode_on') || (exists('b:table_mode_on') && b:table_mode_on == 0)
            TableModeEnable
        endif
        nnoremap <buffer> <Leader>mS :WordyWordy<CR>:setl spell<CR>:Neomake<CR>:DittoSentOn<CR>
        nnoremap <buffer> <Leader>me :execute '!pandoc -o /tmp/' . expand('%:r') . '.html ' . expand('%:p') ' ; '  . $BROWSER . ' /tmp/' . expand('%:r') . '.html'<CR> 
    endif
endfunction
" }}}

" MarkdownInit() {{{"{{{
function! MarkdownInit()
    let g:table_mode_corner = '|'
    nmap <buffer> [[ <Plug>Markdown_MoveToPreviousHeader
    nmap <buffer> ]] <Plug>Markdown_MoveToNextHeader
    nmap gx <buffer> <Plug>Markdown_OpenUrlUnderCursor
    setlocal conceallevel=3
    nnoremap <buffer> <Leader>me :execute '!pandoc -s -o /tmp/' . expand('%:r') . '.html  -t html ' . expand('%:p') . ' ; ' . $BROWSER . ' /tmp/' . expand('%:r') . '.html'<CR>
endfunction
" }}}"}}}

function! OrgInit()
    setlocal foldlevel=2
    let g:table_mode_corner = '+'
endfunction

au! BufEnter *.org let g:table_mode_corner = '+'
au! BufEnter *.md,*.markdown,*.mmd let g:table_mode_corner = '|'

" AUTOCOMMANDS {{{
aug VIMENTER
    " if completion / omnifunction is not provided fall back on default 
    au FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    au FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    " go back to where you left off
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " automatically change dir to the file you are editing
    au BufEnter * try | lchdir %:p:h | catch /.*/ | endtry
    " automatically reload external changes NOTE: doesn't always work properly
    au CursorHold  * silent!  checktime
    au FocusLost   * silent!  wall
    au CmdwinEnter * setlocal updatetime=2000
    au CmdwinLeave * setlocal updatetime=200
    " set dict and thesaurus completion if markup else, tags
    au FileType * if index(g:MARKUP, &filetype) < 0 | setl complete=.,w,t, | else | setl complete=.,w,k,s | endif
    au FileType * call Init()
    au FileType markdown call MarkdownInit()
    au FileType org call OrgInit()
    au BufReadPost,BufNew *.org,*.md,*.mmd nnoremap <buffer> <M-Tab> :TableModeRealign<CR>
    " alternative to ususal execute
    au FileType xhtml,html nnoremap <buffer> <Leader>me :execute '!$BROWSER ' . expand('%:p')<CR>
    au FileType man setl nowrap 
    " on enter open the man page under cursor
    au FileType man nnoremap <buffer> <CR> :execute 'Man ' . expand('<cword>')<CR> 
    au FileType gitcommit setl virtualedit=block spell 
    au FileType gitcommit WordyWordy 
    " make it more like less
    au FileType help,man nnoremap <buffer> q :bd!<CR> | nnoremap <buffer> d <C-d> | nnoremap <buffer> u <C-u> 
    " on enter follow that `tag`
    au FileType help nnoremap <buffer> <CR> <C-]> 
    " easir preview after grepping (use emacs' C-p C-n)
    au FileType qf nnoremap <buffer> <C-n> j<CR><C-w><C-w> | nnoremap <buffer> <C-p> k<CR><C-w><C-w> | nnoremap q :cclose<CR>
aug END
" }}}

" download dictionaries from GitHub if missing {{{
if ! filereadable(g:DICTDIR . 'frequent.dict')
    execute '!curl -o ' . g:DICTDIR . 'frequent.dict https://raw.githubusercontent.com/nl253/VimScript/master/dicts/frequent.dict'
endif
execute 'set dictionary=' .  g:DICTDIR . 'frequent.dict'
if ! filereadable(g:VIMDIR .'thesaurus.txt')
    execute '!curl -o ' . g:VIMDIR . 'thesaurus.txt https://raw.githubusercontent.com/nl253/VimScript/master/thesaurus.txt'
endif
execute 'set thesaurus=' . g:VIMDIR . 'thesaurus.txt'
if ! filereadable(g:DICTDIR .'css.dict')
    execute '!curl -o ' . g:DICTDIR . 'css.dict https://raw.githubusercontent.com/nl253/VimScript/master/dicts/css.dict'
endif
au! FileType css execute 'setlocal dictionary=' . g:DICTDIR . 'css.dict'
if ! filereadable(g:DICTDIR .'mysql.txt')
execute '!curl -o ' . g:DICTDIR . 'mysql.txt https://raw.githubusercontent.com/nl253/VimScript/master/dicts/mysql.txt'
endif
au! FileType sql,mysql execute 'setlocal dictionary=' . g:DICTDIR . 'mysql.txt'
" }}}

colorscheme antares

" markup conversion, recommended {{{
if executable('pandoc')
    command! TOman execute '!pandoc -s -o ' expand('%:p:r') . '.1  -t man ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.1'
    command! TOmarkdown execute '!pandoc -s -o ' expand('%:p:r') . '.md  -t markdown_github ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.md'
    command! TOrst execute '!pandoc -s -o ' expand('%:p:r') . '.rst  -t rst ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.rst'
    command! TOtex execute '!pandoc -s -o ' expand('%:p:r') . '.tex  -t tex ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.tex'
    command! TOwordocx execute '!pandoc -s -o ' expand('%:p:r') . '.docx  -t docx ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.docx'
    command! TOhtml2 execute '!pandoc -s -o ' expand('%:p:r') . '.html  -t html ' . expand('%:p') | sleep 250ms | execute 'vs  ' . expand('%:p:r') . '.html'
endif
if executable('pdftotext')
    command! FROMpdfTOtxt execute '!pdftotext -eol unix "' . expand('%:p') . '"'
    au! BufRead *.pdf execute '!pdftotext -eol unix "' . expand('%:p') . '" | edit ' expand('%:r') . '.txt'
endif
" }}}

if executable('dos2unix')
    command! Dos2Unix !dos2unix -F -n %:p %:p | edit
endif
command! DeleteEmptyLines execute 'g/^\s*$/d'
command! CountOccurances execute printf('%%s/%s//gn', escape(expand('<cword>'), '/')) | normal! ``

" FZF  {{{
let g:PREVIEW = ' --preview "head -n 20 {} " '
let g:IGNORE_REGEXP = "grep -P -v '(\d{4,}$)|(~$)|".
            \"(.*(c|C)ache.*)|(.*\.git.*)|(.*\.(png)|(jpeg)|(bluej)|(ctxt)|(hg)|(svn)".
            \"|(bak)|(jpg)|(so)|(pyc)|(obj)|(out)|(class)|(swp)|(xz)|(svn)|(swp)|(ri))' | grep -v '%' | grep -v elpa | grep -v -i chrome | grep -v timeshift | grep -v -i ideaic "
"
let g:DIR_IGNORE_REGEXP = 'grep -P -v "^/(dev)|(tmp)|(mnt)|(root)"'

command! FZFMru call fzf#run(fzf#wrap({
            \'source':  v:oldfiles,
            \'options': g:FZF_COLORS . '--multi -x +s --preview "head -n 30 {}"',
            \'up':    '50%'
            \}))

command! FZFFileAnchor call fzf#run(fzf#wrap({
            \'source': ' (git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | ' . g:IGNORE_REGEXP . ' | sed s/^..//) 2> /dev/null',
            \'options': '-x +s --reverse --preview "head -n 38 {}"',
            \'up': '80%',
            \}))

command! FZFRecFilesHome execute 'lcd ' . glob("~") | call fzf#run(fzf#wrap({
            \'source': 'find ~ 2>/dev/null | grep -P -v "(\[0-9]{4,}$)|(~$)|(\.(png)|(jpeg)|(bluej)|(ctxt)|(hg)|(svn)|(bak)|(jpg)|(so)|(pyc)|(obj)|(out)|(class)|(swp)|(xz)|(svn)|(swp)|(ri)$)" | grep -v "%" | grep -v chrome | grep -v elpa | grep -v timeshift | grep -v -i ideaic | grep -v ".git" | grep -v -i cache | sed -E "s/^\/home\/\w+\///"',
            \'options': '-x +s --reverse --preview "head -n 38 {}"',
            \'up': '80%',
            \}))
" }}}

" KEYBINDINGS {{{
inoremap <expr> <Tab> pumvisible() ? "\<C-y>\<Space>" : "\<Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
nnoremap <Leader>mS :Neomake<CR>:SyntasticCheck<CR>

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
noremap k gk
noremap j gj

nnoremap <Leader>fed    :e $MYVIMRC<CR>
nnoremap <Leader>fer    :so $MYVIMRC<CR>
nnoremap <Leader>ga     :Git add %:p<Space>
nnoremap <Leader>gb     :Gblame<CR>
nnoremap <Leader>gd     :Gdiff<Space>
nnoremap <Leader>gc     :Gcommit<CR>
nnoremap <Leader>gW     :Gwrite<Space>
nnoremap <Leader>gD     :Gdiff<CR>
nnoremap <Leader>gm     :Gmove<Space>
if len($TMUX) > 1
    nnoremap <Leader>gp     :Gpush<CR>
    nnoremap <Leader>gf     :Gfetch<Space>
endif
nnoremap <Leader>gV     :Gitv!<CR>
nnoremap <Leader>gv     :Gitv<CR>
nnoremap <Leader>g?     :Gitv?<CR>
vnoremap <Leader>gv     :Gitv<CR>
vnoremap <Leader>g?     :Gitv?<CR>
nnoremap <Leader>gs     :Gstatus<CR>

nnoremap <C-s>s         :SaveSession<Space>
nnoremap <C-s><C-s>     :SaveSession<CR>
nnoremap <C-s>o         :OpenSession<Space>
nnoremap <C-s><C-o>     :OpenSession<CR>
nnoremap <C-s>d         :DeleteSession<Space>
nnoremap <C-s><C-d>     :DeleteSession!<CR>
nnoremap <C-s><C-c>     :CloseSession!<CR>
nnoremap <C-s>c         :CloseSession<CR>

nnoremap <C-v> :FZFFileAnchor<CR>
nnoremap <C-x><C-f> :FZFRecFilesHome<CR>
nnoremap <C-x><C-r> :FZFMru<CR>

nnoremap <C-x><C-g> :execute 'Ggrep ' . expand('<cword>') . " * "<CR>
nnoremap <C-x><C-a> :Ag!<CR>

cno w!!<CR> %!sudo tee > /dev/null %<CR>
cno W!<CR> w!<CR>
cno W<CR> w<CR>
cno Wa<CR> wa<CR>
cno WA<CR> wa<CR>
cno Wa!<CR> wa!<CR>
cno WA!<CR> wa!<CR>
cno Wqa<CR> wqa<CR>
cno wQa<CR> wqa<CR>
cno WQA<CR> wqa<CR>
cno wqA<CR> wqa<CR>
cno wqA<CR> wqa<CR>
cno qwa<CR> wqa<CR>
cno Qwa<CR> wqa<CR>
cno qWa<CR> wqa<CR>
cno qwA<CR> wqa<CR>
cno qWA<CR> wqa<CR>
cno QWA<CR> wqa<CR>
cno QwA<CR> wqa<CR>
" }}}

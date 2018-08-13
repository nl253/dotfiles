let g:bash_env_vars = [
            \ 'BASHOPTS',
            \ 'BASHPID',
            \ 'BASH_ALIASES',
            \ 'BASH_ARGC',
            \ 'BASH_ARGV',
            \ 'BASH_CMDS',
            \ 'BASH_COMMAND',
            \ 'BASH_EXECUTION_STRING',
            \ 'BASH_LINENO',
            \ 'BASH_LOADABLES_PATH',
            \ 'BASH_REMATCH',
            \ 'BASH_SOURCE',
            \ 'BASH_SUBSHELL',
            \ 'BASH_VERSINFO',
            \ 'BASH_VERSION',
            \ 'COMP_CWORD',
            \ 'COMP_KEY',
            \ 'COMP_LINE',
            \ 'COMP_POINT',
            \ 'COMP_TYPE',
            \ 'COMP_WORDBREAKS',
            \ 'COMP_WORDS',
            \ 'COPROC',
            \ 'DIRSTACK',
            \ 'EUID',
            \ 'FUNCNAME',
            \ 'GROUPS',
            \ 'HISTCMD',
            \ 'HOSTNAME',
            \ 'HOSTTYPE',
            \ 'LINENO',
            \ 'MACHTYPE',
            \ 'MAPFILE',
            \ 'OLDPWD',
            \ 'OPTARG',
            \ 'OPTIND',
            \ 'OSTYPE',
            \ 'PIPESTATUS',
            \ 'PPID',
            \ 'PWD',
            \ 'RANDOM',
            \ 'READLINE_LINE',
            \ 'READLINE_POINT',
            \ 'REPLY',
            \ 'SECONDS',
            \ 'SHELLOPTS',
            \ 'SHLVL',
            \ 'UID',
            \ 'BASH_COMPAT',
            \ 'BASH_ENV',
            \ 'BASH_XTRACEFD',
            \ 'CDPATH',
            \ 'CHILD_MAX',
            \ 'COLUMNS',
            \ 'COMPREPLY',
            \ 'EMACS',
            \ 'ENV',
            \ 'EXECIGNORE',
            \ 'FCEDIT',
            \ 'FIGNORE',
            \ 'FUNCNEST',
            \ 'GLOBIGNORE',
            \ 'HISTCONTROL',
            \ 'HISTFILE',
            \ 'HISTFILESIZE',
            \ 'HISTIGNORE',
            \ 'HISTSIZE',
            \ 'HISTTIMEFORMAT',
            \ 'HOSTFILE',
            \ 'IFS',
            \ 'IGNOREEOF',
            \ 'INPUTRC',
            \ 'LANG',
            \ 'LC_ALL',
            \ 'LC_COLLATE',
            \ 'LC_CTYPE',
            \ 'LC_MESSAGES',
            \ 'LC_NUMERIC',
            \ 'LC_TIME',
            \ 'LINES',
            \ 'MAIL',
            \ 'MAILCHECK',
            \ 'MAILPATH',
            \ 'OPTERR',
            \ 'PATH',
            \ 'POSIXLY_CORRECT',
            \ 'PROMPT_COMMAND',
            \ 'PROMPT_DIRTRIM',
            \ 'PS0',
            \ 'PS1',
            \ 'PS2',
            \ 'PS3',
            \ 'PS4',
            \ 'SHELL',
            \ 'TIMEFORMAT',
            \ 'TMOUT',
            \ 'TMPDIR',
            \ 'auto_resume',
            \ 'histchars',
            \ ]

let g:bash_keywords = [
            \ 'case',
            \ 'do',
            \ 'done',
            \ 'elif',
            \ 'else',
            \ 'esac',
            \ 'for',
            \ 'if',
            \ 'then',
            \ 'until',
            \ 'while',
            \ ]

let g:bash_builtins = [
            \ 'alias',
            \ 'bind',
            \ 'break',
            \ 'builtin',
            \ 'cd',
            \ 'command',
            \ 'compgen',
            \ 'complete',
            \ 'compopt',
            \ 'continue',
            \ 'coproc',
            \ 'declare',
            \ 'dirs',
            \ 'disown',
            \ 'echo',
            \ 'enable',
            \ 'eval',
            \ 'exec',
            \ 'exit',
            \ 'export',
            \ 'false',
            \ 'fc',
            \ 'fg',
            \ 'fi',
            \ 'getopts',
            \ 'hash',
            \ 'help',
            \ 'history',
            \ 'jobs',
            \ 'kill',
            \ 'let',
            \ 'local',
            \ 'logout',
            \ 'mapfile',
            \ 'popd',
            \ 'printf',
            \ 'pushd',
            \ 'pwd',
            \ 'read',
            \ 'readarray',
            \ 'readonly',
            \ 'return',
            \ 'set',
            \ 'shift',
            \ 'shopt',
            \ 'source',
            \ 'suspend',
            \ 'test',
            \ 'time',
            \ 'times',
            \ 'trap',
            \ 'true',
            \ 'type',
            \ 'typeset',
            \ 'ulimit',
            \ 'umask',
            \ 'unalias',
            \ 'unset',
            \ 'wait'
            \ ]

fu! BashOmniFunc(findstart, base)

    if a:findstart
        " locate the start of the word
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[l:start - 1] =~? '\a'
            let l:start -= 1
        endwhile
        return l:start
    elseif len(a:base) <= 0
        return []
    en

    let l:completions = []

    if a:base =~# '\v[A-Z][_A-Z]{1,}'
        let l:completions += getcompletion(a:base, "environment")
        let l:completions += filter(g:bash_env_vars, 'v:val =~# a:base')

    elseif a:base =~# '\v[-a-z_]+'
        let l:completions += getcompletion(a:base, "shellcmd")
        let l:completions += filter(g:bash_builtins, 'v:val =~# a:base')
        let l:completions += filter(g:bash_keywords, 'v:val =~# a:base')
    en

    return filter(l:completions, 'len(v:val) > 2')
endf
# FZF init # chech if on system # set up aliases in case it is and isn't

# {{{ executeable not found ... Install ... 
if [ ! -x /usr/bin/fzf ] && [ ! -x ~/.fzf/bin/fzf ] && [ ! -x ~/.fzf/bin/fzf ]; then       # look in /usr/bin/ and /bin/ and ~/.fzf/bin/fzf
  if [ -x /usr/bin/git ] || [ -x /bin/git ] ; then                                   # make sure ther is git
    [ -e ~/.fzf ] && rm -rf ~/.fzf                                                   # if there is such a dir, remove
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install # download and install
  fi
fi
# }}}

if [ -x /usr/bin/fzf ] || [ -x ~/.fzf/bin/fzf ] || [ -x /bin/fzf ]; then # {{{

  export FZF_DEFAULT_OPTS="--bind='alt-d:execute(cd {})' --bind='ctrl-d:half-page-down,ctrl-u:half-page-up,alt-p:toggle-preview' --bind='alt-e:execute(\$EDITOR {})' --bind='alt-r:execute(rifle {}),alt-l:execute:(command less -RX {})' --no-mouse --multi --black --margin 3% --prompt=' >> ' --reverse --tiebreak=end,length --color 'hl:117,hl+:1,bg+:232,fg:240,fg+:246'"

  # KEYMAP
  # enter : print to STDOUT
  # ctrl-d : scroll down
  # ctrl-u : scroll up
  # alt-e : edit with $EDITOR
  # alt-d : cd
  # alt-r : execute `rifle` [detects what to use based on file type]
  # alt-l : open in `less`

  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type d -print -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
  export FZF_CTRL_T_OPTS="--select-1 --exit-0"

  export FZF_CTRL_R_OPTS="--sort --exact --preview 'echo {}' --preview-window down:3:hidden --bind '?:toggle-preview'"

  # preview configured to `cat` for files and use `tree` for dirs
  alias fzfp='fzf --preview="[ -f {} ] && head -n 38 {} || tree -l -a --prune -L 4 -F --sort=mtime {}"' # [FZF] with [P]REVIEW

  alias l=fzf-locate.sh # [L]OCATE
  alias c=fzf-cd.sh     # [C]D
  alias p=fzf-pkill.sh  # [P]ROCESSES 

  [ -x /usr/bin/gdrive ] || [ -x /bin/gdrive ] && alias gdrive-fzf='gdrive list | fzf --bind "enter:execute(echo {} | grep -P -o \"^\w+\")"'

else # non fzf solution 

  [ -x /usr/bin/htop ] || [ -x /bin/htop ] && alias p=htop || alias p=top # [P]ROCESSES 

fi # }}}


export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

#export EDITOR='emacsclient -t -c'
export EDITOR='zile'
export FIGNORE='.pyc:~:.o:~:#'

alias grep='grep --ignore-case --binary-files=without-match --exclude="*.pyc" --exclude="*.pyo" --exclude="*#" --exclude="*~" --exclude-dir=".*"'
export GREP_OPTIONS='--ignore-case --binary-files=without-match --exclude="*.pyc" --exclude="*~" --exclude="*#" --exclude-dir=".*"'

alias ls='ls --time-style=iso -F --color=never  --ignore-backups --ignore="*.pyo" --ignore="*.pyc" --ignore="*#"'
alias less='less -I -N'
alias lsof='lsof -n -P'
alias ipython='ipython --no-banner --no-confirm-exit --deep-reload --colors LightBG --pdb'
alias screen='screen -e^Oo -d -R'
alias emacs='emacs -nw'

# python

alias k1='kill -9 %1'
alias k2='kill -9 %2'
alias k3='kill -9 %3'
alias k4='kill -9 %4'
alias k5='kill -9 %5'

# pylint

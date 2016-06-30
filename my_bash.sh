
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

#export EDITOR='emacsclient -t -c'
export EDITOR='zile'
export FIGNORE='.pyc:~:.o:~:#'

alias gpg='gpg --armor'

alias ls='ls --time-style=iso -F --color=never  --ignore-backups --ignore="*.pyo" --ignore="*.pyc" --ignore="*#"'
export ALTERNATE_EDITOR='/usr/bin/emacs --daemon'
alias zile='emacsclient -t -c -a ""'
alias less='less -I -N'
#alias grep='grep -r -n --binary-files=without-match --exclude="*.pyc" --exclude="*~" --exclude="*#" -i --exclude-dir=".*"'
alias grep='grep -r -n '
export GREP_OPTIONS='-i --binary-files=without-match --exclude="*.pyc" --exclude="*~" --exclude="*#" --exclude-dir=".*"'
alias lsof='lsof -n -P'
alias ipython='ipython --no-banner --no-confirm-exit --deep-reload --colors LightBG --pdb'
alias screen='screen -e^Oo -d -R'
alias emacs='emacs -nw'

# python
#export PYTHONPATH=/home/angel/tudou/lib:/home/angel/m-api:$PYTHONPATH

export home=/home/angel
alias k1='kill -9 %1'
alias k2='kill -9 %2'
alias k3='kill -9 %3'
alias k4='kill -9 %4'
alias k5='kill -9 %5'

# pylint
alias pylint='pylint --rcfile=/home/angel/foo/mybash/pylint'
alias autopep8='autopep8 --ignore E501'

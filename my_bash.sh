export EDITOR='emacs -nw'
alias ls='ls -F'

alias lsof='lsof -n -P'
alias ipython='ipython --no-banner --no-confirm-exit'
alias nload='nload -t 1500'
alias screen='screen -l -e^Oo'
alias su='su --login'

# double alias
#alias sudo='sudo --login '

alias emacs='emacs -nw'
alias curl='curl --remote-name --location --proxy socks5h://127.0.0.1:1080'

alias less='less  --IGNORE-CASE'
alias grep='grep --ignore-case -I'
alias pip='pip --proxy socks5h://127.0.0.1:1080'

alias firejail='firejail --apparmor'

# python
export HISTCONTROL=ignorespace

alias k1='kill -9 %1'
alias k2='kill -9 %2'
alias k3='kill -9 %3'
alias k4='kill -9 %4'
alias k5='kill -9 %5'

# gpg
GPG_TTY=$(tty)
export GPG_TTY

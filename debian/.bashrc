# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


httpproxy=http://127.0.0.1:7890
socksproxy=socks5://127.0.0.1:7890

alias setproxy="export http_proxy=$httpproxy; export https_proxy=$httpproxy; export all_proxy=$socksproxy; echo 'Set proxy successfully'"

# 设置取消使用代理
alias unsetproxy="unset http_proxy; unset https_proxy; unset all_proxy; echo 'Unset proxy successfully'"
. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/kina/.local/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
# else
#    if [ -f "/home/kina/.local/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/kina/.local/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/kina/.local/miniconda3/bin:$PATH"
#    fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

alias newchat="mv /home/kina/.cache/chat.toml /home/kina/.cache/chat-$(date +%s).toml"

alias works="~/.config/scripts/works.sh && countdown 25m && notify-send \"Work time is done\""
alias rests="~/.config/scripts/rests.sh && countdown 5m && notify-send \"Rest time is done\""

alias wificonfirm="xdg-open \"http://10.170.1.2:9090/zportal/login?wlanuserip=892b24677379d1ea512821f1e2799460&wlanacname=8401d4e42969489875a0b6149e63678c&ssid=c24e36c874328833576d4435928a84c5&nasip=aa97548fee0077ad407c5fe8d3a7645b&snmpagentip=&mac=f9aeda51bcf7fa0f14c9249cc8862ffe&t=wireless-v2&url=9f9569ff43f49c8cddc7badc7ba5966616542ab7f1e6b57c&apmac=&nasid=8401d4e42969489875a0b6149e63678c&vid=6e87e3dba2deb0e2&port=9bb98834c22d02c9&nasportid=b9d2866090de456862a975341d65743910ad3ec3bc76a5504cb8db7c71d141021eff2733096ea11b\""

alias notesave="cd Documents/obsidian/Obsidian\ Vault && git add . && git commit -m $(date +%s) && git push && cd -"
alias notepull="cd Documents/obsidian/Obsidian\ Vault && git pull && cd -"

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.local/share/bash/rc

# alias ls='ls --color=auto'
# alias grep='grep --color=auto'

clear
show_system_status
PROMPT_DIRTRIM=2
PS1='\n[\[\e[31m\]\u\[\e[0m\] -> \[\e[38;5;208m\]\w\[\e[0m\]]\n\[\e[38;5;208m\]\$\[\e[0m\] '

# minimal PS1
# PS1='[\u \W]\n\$ '

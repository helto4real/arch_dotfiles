#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias lss='ls -fl'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Install all bashrc files
for file in $HOME/.config/bash/*.sh; do
  source "$file"
done

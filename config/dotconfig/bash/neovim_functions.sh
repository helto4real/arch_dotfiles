#!/usr/bin/env bash

function __nssh_usage() {
    echo -e "${ARROW} ${YELLOW}Usage: nssh -s <server> [-d remote_dir]${NC}"
}

function nssh() {
    local remote_dir='/'
    local server=''
    local OPTIND=1
    while getopts "hd:s:" opt; do
        case ${opt} in
            h )
                __nssh_usage
                return 0
                ;;
            d )
                local remote_dir=$OPTARG
                ;;
            s )
                local server=$OPTARG
                ;;
            \? )
                echo -e "${WARNING} ${YELLOW}Invalid option${NC}"
                __nssh_usage
                return 1
                ;;
        esac
    done
    if [ -z $server ]; then
        __nssh_usage
        return 1
    fi
    if [ ! -d ~/.sshfs ]; then mkdir ~/.sshfs > /dev/null 2>&1; fi
    if [ ! -d ~/.sshfs/$server ]; then mkdir ~/.sshfs/$server > /dev/null 2>&1; fi
    # sshfs -o default_permissions $server:$remote_dir $HOME/.sshfs/$server
    sshfs $server:$remote_dir $HOME/.sshfs/$server
    nvim $HOME/.sshfs/$server
    fusermount -zu $HOME/.sshfs/$server
    rm -rf $HOME/.sshfs/$server
}


# give nssh ssh tab completion for servers in ~/.ssh/config
function _nssh() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}')
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _nssh nssh

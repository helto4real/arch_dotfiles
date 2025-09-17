# ======================================================
# Remote Neovim SSH Helper - Edit remote files locally 
# ======================================================

# Helper function to display usage instructions with colored output
function __nssh_usage() {
    echo -e "${ARROW} ${YELLOW}Usage: nssh -s <server> [-d remote_dir]${NC}"
}

# Main function for SSH + Neovim remote editing workflow
# This function:
# 1. Mounts a remote directory using SSHFS
# 2. Opens the mounted directory in Neovim
# 3. Upon exit, cleanly unmounts the directory
function nssh() {
    # Default to root directory if no path specified
    local remote_dir='/'
    local server=''
    local OPTIND=1
    
    # Parse command line options
    while getopts "hd:s:" opt; do
        case ${opt} in
            h )
                # Display help/usage information
                __nssh_usage
                return 0
                ;;
            d )
                # Set the remote directory to mount
                local remote_dir=$OPTARG
                ;;
            s )
                # Set the SSH server to connect to
                local server=$OPTARG
                ;;
            \? )
                # Handle invalid options
                echo -e "${WARNING} ${YELLOW}Invalid option${NC}"
                __nssh_usage
                return 1
                ;;
        esac
    done
    
    # Server parameter is required
    if [ -z $server ]; then
        __nssh_usage
        return 1
    fi
    
    # Create mount point directories if they don't exist
    if [ ! -d ~/.sshfs ]; then mkdir ~/.sshfs > /dev/null 2>&1; fi
    if [ ! -d ~/.sshfs/$server ]; then mkdir ~/.sshfs/$server > /dev/null 2>&1; fi
    
    # Mount the remote directory using SSHFS
    # Commented line below shows alternate mounting with explicit permissions
    # sshfs -o default_permissions $server:$remote_dir $HOME/.sshfs/$server
    sshfs $server:$remote_dir $HOME/.sshfs/$server
    
    # Open the mounted directory in Neovim
    nvim $HOME/.sshfs/$server
    
    # After Neovim exits, unmount the filesystem
    fusermount -zu $HOME/.sshfs/$server
    
    # Clean up the mount point directory
    rm -rf $HOME/.sshfs/$server
}


# Tab completion for the nssh command
# Provides SSH server names from ~/.ssh/config as completion options
function _nssh() {
    local cur prev opts
    COMPREPLY=()
    
    # Get current and previous words from command line
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Extract server names from SSH config file
    opts=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}')
    
    # Generate completion matches based on current input
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
autoload -Uz compinit
compinit
# Register the completion function for nssh command
compdef _nssh nssh

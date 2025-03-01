# ===== Default applications configuration =====
export BROWSER="zen"       # Set default browser to zen
export EDITOR="nvim"       # Set default editor for command line operations
export VISUAL="nvim"       # Set default editor for GUI applications

# ===== YubiKey and GPG configuration =====
# Configure GPG with YubiKey for SSH authentication
export KEYID=392AFB734FE22D59  # Your personal GPG key identifier
export GPG_TTY=$(tty)          # Tell GPG which terminal to use for PIN entry

# Force using GPG version 2 instead of version 1
alias gpg=gpg2                 # Modern GPG implementation with YubiKey support

# ===== GPG Agent Management =====
# Start the gpg-agent daemon if not already running
# This agent manages private keys and handles authentication requests
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
    gpg-connect-agent /bye >/dev/null 2>&1
fi

# ===== SSH Authentication via GPG =====
# Configure SSH to use GPG agent instead of standard SSH agent
# This allows using YubiKey for SSH authentication
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    # Set socket path for GPG's SSH agent component
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

# Update GPG agent with current TTY information
# This ensures GPG prompts appear in the correct terminal
gpg-connect-agent updatestartuptty /bye >/dev/null

# Problems with yubikey
Check the script for hints:
```bash
#!/bin/bash
#GPG Agent & Yubikey
#assumes you're running ArchLinux and zsh

#Install the necessary packages
packer -S pcsc-tools ccid libusb-compat

## Start the services
sudo systemctl enable pcscd.service
sudo systemctl start pcscd.service

#Write necessary configs to .zshrc
cat <<EOF >> ~/.zshrc
#Making sure we're using gpg2
alias gpg=gpg2

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
          gpg-connect-agent /bye >/dev/null 2>&1
fi

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null
EOF

source ~/.zshrc
```

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.config/bash
cp -r ./secret/gpgkeys.sh ~/.config/bash/
ansible-vault decrypt ~/.config/bash/gpgkeys.sh --vault-password-file ~/.ansible-vault/vault.secret

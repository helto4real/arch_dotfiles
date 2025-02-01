# Copy the configuration file to the user's home directory
mkdir -p $HOME/.kube
# get script directory
DOTFILES_DIR="$HOME/.dotfiles"
echo "DOTFILES_DIR: $DOTFILES_DIR"
# Make sure the file exists and report error if not and exit
if [ ! -f $DOTFILES_DIR/files/k8s/config ]; then
    echo "Error: $DOTFILES_DIR/files/k8s/config does not exist"
    exit 1
fi

VAULT_SECRET=$HOME/.ansible-vault/vault.secret

cp -i $DOTFILES_DIR/files/k8s/config $HOME/.kube/config
# Use ansible to decrypt the file
ansible-vault decrypt $HOME/.kube/config --vault-password-file $VAULT_SECRET

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

yay -S oh-my-bash-git
mkdir -p $HOME/.oh-my-bash/themes/axin
# copy the theme to the themes directory
cp ~/.dotfiles/files/oh-my-bash/themes/axin.theme.sh $HOME/.oh-my-bash/themes/axin/axin.theme.sh


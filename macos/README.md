# dotfiles



```

git clone http://github.com/or-feus/dotfiles ~/.dotfiles

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/macos/.vimrc ~/.config/nvim/init.vim
ln -s ~/.dotfiles/macos/coc-settings.json ~/.config/nvim/coc-settings.json
cp ~/.dotfiles/macos/.vimrc.local ~


# zsh
git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
ln -sf ~/.dotfiles/.zshrc ~
cp ~/.dotfiles/macos/.zshrc.local ~
exec zsh
p10k configure

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/.dotfiles/macos/.tmux.conf ~


# alacritty
mkdir -p ~/.config/alacritty
ln -s ~/.dotfiles/macos/alacritty.yml ~/.config/alacritty/.
```
---
### Additionally, you may need `rust-analyzer` installation

`brew install rust-analyzer`

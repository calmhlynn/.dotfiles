# dotfiles

아래의 프로그램에 대한 세팅 파일
* zsh
* tmux
* alacritty
* etc.

neovim의 세팅은 [nvim.lua](https://github.com/or-feus/nvim.lua)

---
#### 설치 체크 목록
* rust
* rust-analyzer
* nerd-font
* sqlite
* python-pip3
---

####  try

```
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cd "$(mktemp -d)"
git clone http://github.com/or-feus/dotfiles

# zsh
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-syntax-highlighting 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting  

# zsh-autosuggestions 
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions

# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp -i .zshrc ~

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp dotfiles/.tmux.conf ~

# alacritty
mkdir -p ~/.config/alacritty
cp dotfiles/alacritty/alacritty.yml ~/.config/alacritty/
alacritty migrate
```
---
<br>
MIT 라이선스

# dotfiles

이 dotfiles은 아래의 프로그램에 대한 세팅 파일입니다.
* zsh
* tmux
* alacritty
---

neovim의 세팅은 [nvim.lua](https://github.com/or-feus/nvim.lua)
리포지토리에구성되어 있습니다.


---

```
cd "$(mktemp -d)"
git clone http://github.com/or-feus/dotfiles

# zsh
git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
cp dotfiles/.zshrc ~
cp dotfiles/.zshrc.local ~
exec zsh
p10k configure

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

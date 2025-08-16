
install by pacman
```bash
pacman -S git curl wget neovim zsh sddm \
nvidia nvidia-utils egl-wayland vulkan-icd-loader \
hyprland wayland wayland-protocols xorg-xwayland \
ttf-hack-nerd ttf-nerd-fonts-symbols \
waybar hyprpaper \
yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick \
noto-fonts-cjk noto-fonts-emoji  \ # only korean
fcitx5 fcitx5-hangul fcitx5-configtool
```


install `yay`

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

install `wezterm`

```bash
git clone https://aur.archlinux.org/wezterm-git
cd wezterm-git
makepkg -si
```

install by yay
```bash
yay -S google-chrome \
wlogout
```


```bash
pacman -S git curl wget neovim zsh sddm \
nvidia nvidia-utils egl-wayland vulkan-icd-loader\
hyprland wayland wayland-protocols xorg-xwayland \
ttf-hack-nerd ttf-nerd-fonts-symbols 
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


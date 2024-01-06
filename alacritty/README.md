### Alacritty Configures

Step 1. install Alacritty
```
brew install alacritty
```

Step 2. install hack font
```
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

Step 3. set configure file
```
mkdir -p ~/.config/alacritty
mv alacritty.yml ~/.config/alacritty/
alacritty migrate
```



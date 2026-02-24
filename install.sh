#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$1"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$1"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$1" >&2; exit 1; }

detect_pkg_manager() {
    if [[ "$OS" == "Darwin" ]]; then
        echo "brew"
    elif command -v apt-get &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    else
        error "unsupported package manager"
    fi
}

install_system_packages() {
    local pm
    pm="$(detect_pkg_manager)"
    info "installing system packages via $pm"

    case "$pm" in
        brew)
            if ! command -v brew &>/dev/null; then
                info "installing Homebrew"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install zsh git git-lfs tmux curl unzip fzf
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y zsh git git-lfs tmux curl unzip build-essential fzf
            ;;
        dnf)
            sudo dnf install -y zsh git git-lfs tmux curl unzip gcc gcc-c++ make fzf
            ;;
        pacman)
            sudo pacman -Syu --noconfirm --needed zsh git git-lfs tmux curl unzip base-devel fzf
            ;;
    esac

    git lfs install
}

install_neovim() {
    local install_dir="$HOME/.local/nvim"

    if [[ -d "$install_dir" ]]; then
        info "neovim already installed at $install_dir"
        return
    fi

    info "installing neovim from GitHub releases"
    local arch
    arch="$(uname -m)"

    local tarball
    if [[ "$OS" == "Darwin" ]]; then
        case "$arch" in
            arm64)  tarball="nvim-macos-arm64.tar.gz" ;;
            x86_64) tarball="nvim-macos-x86_64.tar.gz" ;;
            *)      error "unsupported architecture: $arch" ;;
        esac
    else
        case "$arch" in
            x86_64)  tarball="nvim-linux-x86_64.tar.gz" ;;
            aarch64) tarball="nvim-linux-arm64.tar.gz" ;;
            *)       error "unsupported architecture: $arch" ;;
        esac
    fi

    local url="https://github.com/neovim/neovim/releases/latest/download/${tarball}"
    local tmp
    tmp="$(mktemp -d)"

    curl -fsSL "$url" | tar xz -C "$tmp" --strip-components=1
    mv "$tmp" "$install_dir"

    mkdir -p "$HOME/.local/bin"
    ln -sf "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"
    info "neovim installed to $install_dir"
}

install_ghostty() {
    if [[ -n "${SSH_CLIENT:-}" || -n "${SSH_TTY:-}" || -n "${SSH_CONNECTION:-}" ]]; then
        warn "SSH session detected — skipping ghostty (GUI terminal)"
        return
    fi

    if command -v ghostty &>/dev/null; then
        info "ghostty already installed"
        return
    fi

    info "installing ghostty"
    if [[ "$OS" == "Darwin" ]]; then
        brew install --cask ghostty
    else
        local version arch url install_dir
        install_dir="$HOME/.local/bin"

        version="$(curl -fsSL "https://api.github.com/repos/pkgforge-dev/ghostty-appimage/releases/latest" \
            | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')"
        arch="$(uname -m)"

        url="https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v${version}/Ghostty-${version}-${arch}.AppImage"

        mkdir -p "$install_dir"
        curl -fsSL -o "${install_dir}/ghostty" "$url"
        chmod +x "${install_dir}/ghostty"
        info "ghostty ${version} installed to ${install_dir}/ghostty"
    fi
}

install_rust() {
    if command -v rustup &>/dev/null; then
        info "rustup already installed, updating"
        rustup update
    else
        info "installing rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "${CARGO_HOME:-$HOME/.cargo}/env"
    fi
}

install_cargo_tools() {
    local -a crates=(starship lsd bat ripgrep git-delta stylua lspmux)

    for crate in "${crates[@]}"; do
        if cargo install --list | grep -q "^${crate} "; then
            info "$crate already installed"
        else
            info "installing $crate"
            cargo install "$crate"
        fi
    done
}

install_fonts() {
    local font_dir font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
    local tmp_zip

    if [[ "$OS" == "Darwin" ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi

    if ls "$font_dir"/Hack*Nerd* &>/dev/null; then
        info "Hack Nerd Font already installed"
        return
    fi

    info "installing Hack Nerd Font"
    mkdir -p "$font_dir"
    tmp_zip="$(mktemp)"
    curl -fsSL -o "$tmp_zip" "$font_url"
    unzip -o "$tmp_zip" -d "$font_dir" '*.ttf'
    rm -f "$tmp_zip"

    if [[ "$OS" != "Darwin" ]]; then
        fc-cache -f "$font_dir"
    fi
}

link() {
    local src="$1" dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        local cur
        cur="$(readlink "$dst")"
        if [[ "$cur" == "$src" ]]; then
            return
        fi
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        warn "backing up $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    info "linked $dst → $src"
}

create_symlinks() {
    info "creating symlinks"

    link "$DOTFILES/zsh/.zshrc"      "$HOME/.zshrc"
    link "$DOTFILES/nvim"            "$HOME/.config/nvim"
    link "$DOTFILES/tmux/tmux.conf"  "$HOME/.config/tmux/tmux.conf"
    link "$DOTFILES/bat"             "$HOME/.config/bat"
    link "$DOTFILES/ghostty"         "$HOME/.config/ghostty"
    link "$DOTFILES/.gitconfig"      "$HOME/.gitconfig"
    link "$DOTFILES/sshconfig"       "$HOME/.ssh/config"

    if [[ "$OS" == "Linux" ]]; then
        link "$DOTFILES/systemd/user/lspmux.service" \
             "$HOME/.config/systemd/user/lspmux.service"
    fi
}

setup_lspmux_service() {
    if [[ "$OS" == "Linux" ]]; then
        info "enabling lspmux systemd service"
        systemctl --user daemon-reload
        systemctl --user enable --now lspmux.service
    elif [[ "$OS" == "Darwin" ]]; then
        local plist_dir="$HOME/Library/LaunchAgents"
        local plist="$plist_dir/com.lspmux.plist"
        local cargo_bin="${CARGO_HOME:-$HOME/.cargo}/bin/lspmux"

        if [[ -f "$plist" ]]; then
            info "lspmux LaunchAgent already exists"
            return
        fi

        info "creating lspmux LaunchAgent"
        mkdir -p "$plist_dir"
        cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.lspmux</string>
    <key>ProgramArguments</key>
    <array>
        <string>${cargo_bin}</string>
        <string>server</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/lspmux.out.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/lspmux.err.log</string>
</dict>
</plist>
PLIST
        launchctl load "$plist"
    fi
}

setup_shell() {
    local zsh_path
    zsh_path="$(which zsh)"

    if [[ "$SHELL" == "$zsh_path" ]]; then
        info "zsh is already the default shell"
        return
    fi

    if ! grep -qF "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    info "changing default shell to zsh"
    chsh -s "$zsh_path"
}

setup_path() {
    export PATH="$HOME/.local/bin:${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
}

post_install() {
    if command -v bat &>/dev/null; then
        info "rebuilding bat cache"
        bat cache --build
    fi
}

main() {
    info "dotfiles installer — $(date)"
    info "OS: $OS | DOTFILES: $DOTFILES"

    install_system_packages
    install_neovim
    install_ghostty
    install_rust
    install_cargo_tools
    install_fonts
    create_symlinks
    setup_path
    setup_lspmux_service
    setup_shell
    post_install

    info "done! restart your shell or run: exec zsh"
}

main "$@"

#!/usr/bin/env bash
if [ -z "${BASH_VERSION:-}" ]; then exec bash "$0" "$@"; fi
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
FAILED_STEPS=""
NVIM_CHANNEL="stable"

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$1"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$1"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$1" >&2; exit 1; }

run_step() {
    local step="$1"
    if "$step"; then
        return 0
    fi
    warn "step failed: $step"
    FAILED_STEPS="${FAILED_STEPS}${FAILED_STEPS:+ }${step}"
}

setup_path() {
    export PATH="$HOME/.local/bin:${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"

    if [[ -f "${CARGO_HOME:-$HOME/.cargo}/env" ]]; then
        source "${CARGO_HOME:-$HOME/.cargo}/env"
    fi

    if [[ "$OS" == "Darwin" ]]; then
        local brew_bin
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [[ -x "$brew_bin" ]]; then
                eval "$("$brew_bin" shellenv)"
                break
            fi
        done
    fi
}

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
                setup_path
            fi
            brew install zsh git git-lfs tmux curl unzip sevenzip fzf
            ;;
        apt)
            sudo apt-get update || warn "apt-get update failed, using cached package lists"
            sudo apt-get install -y zsh git git-lfs tmux curl unzip p7zip-full build-essential clang pkg-config fontconfig fzf
            ;;
        dnf)
            sudo dnf install -y zsh git git-lfs tmux curl unzip 7zip gcc gcc-c++ make clang pkgconf-pkg-config fontconfig fzf
            ;;
        pacman)
            sudo pacman -Syu --noconfirm --needed zsh git git-lfs tmux curl unzip p7zip base-devel clang pkgconf fontconfig fzf
            ;;
    esac
}

setup_git_lfs() {
    if ! command -v git-lfs &>/dev/null; then
        warn "skipping git-lfs setup: git-lfs not found"
        return
    fi

    git lfs install --skip-repo
}

nvim_tarball() {
    local arch
    arch="$(uname -m)"

    if [[ "$OS" == "Darwin" ]]; then
        case "$arch" in
            arm64)  echo "nvim-macos-arm64.tar.gz" ;;
            x86_64) echo "nvim-macos-x86_64.tar.gz" ;;
            *)      error "unsupported architecture: $arch" ;;
        esac
    else
        case "$arch" in
            x86_64)  echo "nvim-linux-x86_64.tar.gz" ;;
            aarch64) echo "nvim-linux-arm64.tar.gz" ;;
            *)       error "unsupported architecture: $arch" ;;
        esac
    fi
}

nvim_install_dir() {
    if [[ "${1:-$NVIM_CHANNEL}" == "nightly" ]]; then
        echo "$HOME/.local/nvim-nightly"
    else
        echo "$HOME/.local/nvim"
    fi
}

link_nvim() {
    local channel dir

    mkdir -p "$HOME/.local/bin"
    ln -sf "$(nvim_install_dir)/bin/nvim" "$HOME/.local/bin/nvim"

    for channel in stable nightly; do
        dir="$(nvim_install_dir "$channel")"
        if [[ -x "$dir/bin/nvim" ]]; then
            ln -sf "$dir/bin/nvim" "$HOME/.local/bin/nvim-$channel"
        fi
    done
}

nvim_stable_is_current() {
    local install_dir="$1" installed_ver latest_ver

    installed_ver="$("$install_dir/bin/nvim" --version 2>/dev/null | awk 'NR==1{print $2}')" || installed_ver=""
    latest_ver="$(curl -fsSL "https://api.github.com/repos/neovim/neovim/releases/latest" \
        | grep '"tag_name"' | cut -d'"' -f4)" || latest_ver=""

    if [[ -z "$latest_ver" ]]; then
        warn "cannot query latest neovim release, keeping ${installed_ver:-existing} install"
        return 0
    fi
    if [[ "$installed_ver" == "$latest_ver" ]]; then
        info "neovim $installed_ver is already up to date"
        return 0
    fi

    info "upgrading neovim: $installed_ver → $latest_ver"
    return 1
}

install_neovim() {
    local install_dir url tmp
    install_dir="$(nvim_install_dir)"

    if [[ "$NVIM_CHANNEL" == "nightly" ]]; then
        url="https://github.com/neovim/neovim/releases/download/nightly/$(nvim_tarball)"
    else
        url="https://github.com/neovim/neovim/releases/latest/download/$(nvim_tarball)"
        if [[ -d "$install_dir" ]] && nvim_stable_is_current "$install_dir"; then
            link_nvim
            return
        fi
    fi

    info "installing neovim ($NVIM_CHANNEL) from GitHub releases"
    tmp="$(mktemp -d)"

    mkdir -p "$HOME/.local/bin"
    curl -fsSL "$url" | tar xz -C "$tmp" --strip-components=1
    rm -rf "$install_dir"
    mv "$tmp" "$install_dir"

    link_nvim
    info "neovim installed to $install_dir"
    "$install_dir/bin/nvim" --version | awk 'NR==1'
}

install_appimage_runtime() {
    if [[ "$OS" == "Darwin" ]] || ! command -v dpkg &>/dev/null; then
        return
    fi

    if dpkg -s libfuse2t64 &>/dev/null || dpkg -s libfuse2 &>/dev/null; then
        return
    fi

    info "installing libfuse2 for AppImage support"
    sudo apt-get install -y libfuse2t64 \
        || sudo apt-get install -y libfuse2 \
        || warn "libfuse2 unavailable; AppImages may not run"
}

install_ghostty() {
    if [[ -n "${SSH_CLIENT:-}" || -n "${SSH_TTY:-}" || -n "${SSH_CONNECTION:-}" ]]; then
        warn "SSH session detected — skipping ghostty (GUI terminal)"
        return
    fi

    if [[ "$OS" == "Darwin" ]]; then
        if brew list --cask ghostty &>/dev/null; then
            info "ghostty already installed"
            return
        fi
        info "installing ghostty"
        brew install --cask ghostty
        return
    fi

    if command -v ghostty &>/dev/null; then
        info "ghostty already installed"
        return
    fi

    info "installing ghostty"
    local version arch url install_dir
    install_dir="$HOME/.local/bin"

    version="$(curl -fsSL "https://api.github.com/repos/pkgforge-dev/ghostty-appimage/releases/latest" \
        | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')" || version=""
    if [[ -z "$version" ]]; then
        warn "cannot query latest ghostty release, skipping"
        return
    fi
    arch="$(uname -m)"

    url="https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v${version}/Ghostty-${version}-${arch}.AppImage"

    mkdir -p "$install_dir"
    curl -fsSL -o "${install_dir}/ghostty" "$url"
    chmod +x "${install_dir}/ghostty"
    info "ghostty ${version} installed to ${install_dir}/ghostty"

    install_appimage_runtime
}

install_rust() {
    if command -v rustup &>/dev/null; then
        info "rustup already installed, updating"
        rustup update || warn "rustup update failed"
        return
    fi

    if [[ -x "${CARGO_HOME:-$HOME/.cargo}/bin/rustup" ]]; then
        warn "rustup exists but is not on PATH, skipping install"
        return
    fi

    info "installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "${CARGO_HOME:-$HOME/.cargo}/env"
}

install_cargo_tools() {
    if ! command -v cargo &>/dev/null; then
        warn "skipping cargo tools: cargo not found"
        return
    fi

    local -a crates=(starship lsd bat ripgrep git-delta stylua zoxide tree-sitter-cli)
    local installed
    installed="$(cargo install --list)" || installed=""

    for crate in "${crates[@]}"; do
        if grep -q "^${crate} " <<<"$installed"; then
            info "$crate already installed"
        elif [[ "$crate" == "tree-sitter-cli" ]]; then
            info "installing $crate"
            cargo install --locked "$crate" || warn "failed to install $crate"
        else
            info "installing $crate"
            cargo install "$crate" || warn "failed to install $crate"
        fi
    done
}

install_hack_font() {
    local font_dir="$1" tmp_zip
    local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"

    if ls "$font_dir"/Hack*Nerd* &>/dev/null; then
        info "Hack Nerd Font already installed"
        return
    fi

    info "installing Hack Nerd Font"
    tmp_zip="$(mktemp)"
    if ! curl -fsSL -o "$tmp_zip" "$url"; then
        rm -f "$tmp_zip"
        warn "Hack Nerd Font download failed"
        return
    fi
    unzip -o "$tmp_zip" -d "$font_dir" '*.ttf'
    rm -f "$tmp_zip"
}

install_sarasa_font() {
    local font_dir="$1" dest="$1/SarasaMonoK"
    local sevenzip url tmp_dir api_json

    if ls "$dest"/SarasaMonoK-*.ttf &>/dev/null; then
        info "Sarasa Mono K already installed"
        return
    fi

    sevenzip="$(command -v 7z || command -v 7zz || true)"
    if [[ -z "$sevenzip" ]]; then
        warn "7z not found, skipping Sarasa Mono K"
        return
    fi

    api_json="$(curl -fsSL "https://api.github.com/repos/be5invis/Sarasa-Gothic/releases/latest")" || api_json=""
    url="$(grep -m1 -oE 'https://[^"]+/SarasaMonoK-TTF-[0-9.]+\.7z' <<<"$api_json")" || url=""
    if [[ -z "$url" ]]; then
        warn "cannot find Sarasa Mono K release asset"
        return
    fi

    info "installing Sarasa Mono K"
    tmp_dir="$(mktemp -d)"
    if ! curl -fsSL -o "$tmp_dir/sarasa.7z" "$url"; then
        rm -rf "$tmp_dir"
        warn "Sarasa Mono K download failed"
        return
    fi

    mkdir -p "$dest"
    "$sevenzip" x -y -o"$dest" "$tmp_dir/sarasa.7z" >/dev/null || warn "Sarasa Mono K extraction failed"
    rm -rf "$tmp_dir"
}

install_fonts() {
    local font_dir

    if [[ "$OS" == "Darwin" ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi
    mkdir -p "$font_dir"

    install_hack_font "$font_dir"
    install_sarasa_font "$font_dir"

    if [[ "$OS" != "Darwin" ]]; then
        fc-cache -f "$font_dir" || warn "fc-cache failed"
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
        local backup
        backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        warn "backing up $dst → $backup"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    info "linked $dst → $src"
}

create_symlinks() {
    info "creating symlinks"

    link "$DOTFILES/zsh/.zshrc"      "$HOME/.zshrc"
    link "$DOTFILES/nvim"            "$HOME/.config/nvim"
    link "$DOTFILES/tmux"            "$HOME/.config/tmux"
    link "$DOTFILES/bat"             "$HOME/.config/bat"
    link "$DOTFILES/ghostty"         "$HOME/.config/ghostty"
    link "$DOTFILES/herdr" "$HOME/.config/herdr"
    link "$DOTFILES/.gitconfig"      "$HOME/.gitconfig"
    link "$DOTFILES/.gitexclude"     "$HOME/.gitexclude"

}

install_treesitter() {
    if ! command -v nvim &>/dev/null; then
        warn "skipping Neovim bootstrap: nvim not found"
        return
    fi

    info "bootstrapping Neovim plugins and Tree-sitter parsers"
    nvim --headless +qa || warn "neovim bootstrap reported errors"
}

install_tmux_plugins() {
    if ! command -v tmux &>/dev/null; then
        warn "skipping tmux plugins: tmux not found"
        return
    fi

    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ ! -d "$tpm_dir" ]]; then
        info "installing TPM"
        if ! git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
            warn "TPM clone failed"
            return
        fi
    fi

    info "installing tmux plugins"
    local tpm_session="_tpm_install"
    if ! tmux has-session -t "$tpm_session" 2>/dev/null; then
        if ! tmux new-session -d -s "$tpm_session" 2>/dev/null; then
            warn "cannot start tmux server, skipping plugin install"
            return
        fi
    fi
    tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
    "$tpm_dir/bin/install_plugins" || warn "tmux plugin install failed"
    tmux kill-session -t "$tpm_session" 2>/dev/null || true
}

current_shell() {
    if [[ "$OS" == "Darwin" ]]; then
        dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}'
    else
        getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7
    fi
}

setup_shell() {
    local zsh_path current

    if ! zsh_path="$(command -v zsh)"; then
        warn "skipping shell setup: zsh not found"
        return
    fi

    current="$(current_shell)" || current=""
    if [[ "$current" == "$zsh_path" ]]; then
        info "zsh is already the default shell"
        return
    fi

    if ! grep -qF "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    info "changing default shell to zsh"
    chsh -s "$zsh_path" || warn "chsh failed — run manually: chsh -s $zsh_path"
}

setup_bat_theme() {
    if ! command -v bat &>/dev/null; then
        warn "skipping bat theme setup: bat not found"
        return
    fi

    local themes_dir
    themes_dir="$(bat --config-dir)/themes"

    mkdir -p "$themes_dir"

    local theme_file="${DOTFILES}/bat/themes/Catppuccin Mocha.tmTheme"
    if [[ ! -f "$themes_dir/Catppuccin Mocha.tmTheme" ]]; then
        if [[ -f "$theme_file" ]]; then
            cp "$theme_file" "$themes_dir/"
        else
            info "downloading Catppuccin Mocha theme for bat"
            curl -fsSL \
                "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" \
                -o "$themes_dir/Catppuccin Mocha.tmTheme"
        fi
    fi

    info "rebuilding bat cache"
    bat cache --build || warn "bat cache build failed"
}

install_private_dotfiles() {
    "$HOME/.sdotfiles/install.sh"
}

main() {
    case "${1:-stable}" in
        stable|nightly) NVIM_CHANNEL="${1:-stable}" ;;
        *) error "usage: install.sh [stable|nightly]" ;;
    esac

    info "dotfiles installer — $(date)"
    info "OS: $OS | DOTFILES: $DOTFILES | nvim: $NVIM_CHANNEL"

    setup_path

    run_step install_system_packages
    run_step install_neovim
    run_step install_ghostty
    run_step install_rust
    run_step install_cargo_tools
    run_step install_fonts
    run_step create_symlinks
    run_step setup_git_lfs
    run_step setup_shell
    run_step install_treesitter
    run_step install_tmux_plugins
    run_step setup_bat_theme

    if [[ -x "$HOME/.sdotfiles/install.sh" ]]; then
        info "running private dotfiles installer"
        run_step install_private_dotfiles
    fi

    if [[ -n "$FAILED_STEPS" ]]; then
        warn "completed with failed steps: $FAILED_STEPS"
        exit 1
    fi

    info "done! nvim → $(nvim_install_dir)"
    info "restart your shell or run: exec zsh"
}

main "$@"

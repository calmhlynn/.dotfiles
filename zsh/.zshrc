[[ -o interactive ]] || return
export LANG=en_US.UTF-8

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

stty stop undef

bindkey -e

setopt always_to_end complete_in_word auto_cd
HISTSIZE=9000000
SAVEHIST=9000000

[[ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

setopt extended_history hist_ignore_all_dups hist_reduce_blanks inc_append_history hist_ignore_space
setopt share_history

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='none'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-history-substring-search

bindkey $'\e[A' history-substring-search-up      # Normal mode up
bindkey $'\e[B' history-substring-search-down    # Normal mode down
bindkey $'\eOA' history-substring-search-up      # Application mode up
bindkey $'\eOB' history-substring-search-down    # Application mode down

bindkey $'\e[1;2C' forward-word                  # Shift+Right
bindkey $'\e[1;2D' backward-word                 # Shift+Left

zinit ice depth=1

ZCOMPLDIR="${ZINIT[COMPLETIONS_DIR]:-$HOME/.local/share/zinit/completions}"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

ZSH_AUTOSUGGEST_USE_ASYNC=1

zinit ice atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload -Uz compinit bashcompinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
bashcompinit
zinit cdreplay -q

zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

__git_remote_repositories() {}
__git_local_repositories() {}
_cmdambivalent() { (( CURRENT > 1 )) && _normal; }

if (( $+commands[nvim] )); then
    export EDITOR='nvim'
elif (( $+commands[vim] )); then
    export EDITOR='vim'
fi

if (( $+commands[tmux] )); then
    alias t='tmux'
fi

if (( $+commands[lsd] )); then
    alias ls='lsd'
fi
alias l='ls -lgt'
alias la='ls -a'
alias lla='ls -lgat'
alias lt='ls --tree -t'

if [[ $OSTYPE == linux* ]] && (( $+commands[systemctl] )); then
    alias sc='systemctl'
    alias ssc='sudo systemctl'
    compdef sc=systemctl
    compdef ssc=systemctl
fi

if (( $+commands[herdr] )); then
  source <(herdr completion zsh)
fi


if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi
export PATH="$HOME/.local/bin:$PATH"

autoload -Uz add-zsh-hook
add-zsh-hook precmd (){ print -n '\e[5 q' }

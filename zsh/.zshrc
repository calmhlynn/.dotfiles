[[ -o interactive ]] || return
export LANG=en_US.UTF-8

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

stty stop undef

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

function zvm_after_init() {

    local key_up=$'\e[A'       # Normal mode
    local key_down=$'\e[B'     # Normal mode
    local key_up_app=$'\eOA'   # Application mode 
    local key_down_app=$'\eOB' # Application mode 

    zvm_bindkey viins "$key_up" history-substring-search-up
    zvm_bindkey viins "$key_up_app" history-substring-search-up
    zvm_bindkey viins "$key_down" history-substring-search-down
    zvm_bindkey viins "$key_down_app" history-substring-search-down

    local key_shift_right=$'\e[1;2C'
    local key_shift_left=$'\e[1;2D'

    zvm_bindkey viins "$key_shift_right" vi-forward-word
    zvm_bindkey viins "$key_shift_left" vi-backward-word
    zvm_bindkey vicmd "$key_shift_right" vi-forward-word
    zvm_bindkey vicmd "$key_shift_left" vi-backward-word
}

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

ZCOMPLDIR="${ZINIT[COMPLETIONS_DIR]:-$HOME/.local/share/zinit/completions}"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

ZSH_AUTOSUGGEST_USE_ASYNC=1

zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \


autoload -Uz compinit bashcompinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
bashcompinit

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

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

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

[[ -o interactive ]] || return

export LANG=en_US.UTF-8

stty stop undef

setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_LEX_WORDS HIST_REDUCE_BLANKS SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_SPACE
HISTSIZE=9000000
SAVEHIST=9000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='none'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

ZCOMPLDIR="${ZINIT[COMPLETIONS_DIR]:-$HOME/.local/share/zinit/completions}"

if (( $+commands[just] )); then
    [[ ! -f "$ZCOMPLDIR/_just" ]] && just --completions zsh > "$ZCOMPLDIR/_just"
fi

zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

zinit light zsh-users/zsh-history-substring-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if [[ -n "$ZELLIJ" ]]; then
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
fi

zinit wait'0' lucid for \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

ZSH_AUTOSUGGEST_USE_ASYNC=1

if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
fi

if (( $+commands[lsd] )); then
    alias ls='lsd'
fi
alias l='ls -lgt'
alias la='ls -a'
alias lla='ls -lgat'
alias lt='ls --tree -t'

if (( $+commands[zellij] )); then
    [[ ! -f "$ZCOMPLDIR/_zellij" ]] && zellij setup --generate-completion zsh > "$ZCOMPLDIR/_zellij"

    alias zj='zellij'

    function _zellij_tab_name_update() {
        if [[ -n "$ZELLIJ" ]]; then
            local tab_name="${PWD##*/}"
            [[ "$tab_name" == "$USER" ]] && tab_name="~"
            [[ -n "$SSH_CONNECTION" ]] && tab_name="${HOST%%.*}:$tab_name"
            command zellij action rename-tab "$tab_name" 2>/dev/null
        fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _zellij_tab_name_update
    _zellij_tab_name_update

    function ssh() {
        if [[ -n "$ZELLIJ" ]]; then
            local arg target_host
            for arg in "$@"; do
                [[ "$arg" != -* ]] && target_host="$arg"
            done
            [[ -n "$target_host" ]] && command zellij action rename-tab "$target_host" 2>/dev/null
            command ssh "$@"
            local ret=$?
            _zellij_tab_name_update
            return $ret
        else
            command ssh "$@"
        fi
    }
fi

if (( $+commands[gpgconf] )); then
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
    gpgconf --launch gpg-agent
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

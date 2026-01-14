[[ -o interactive ]] || return
export LANG=en_US.UTF-8

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

zmodload zsh/terminfo
zinit light zsh-users/zsh-history-substring-search
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

ZCOMPLDIR="${ZINIT[COMPLETIONS_DIR]:-$HOME/.local/share/zinit/completions}"

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

zinit cdreplay

if (( $+commands[nvim] )); then
    export EDITOR='nvim'
elif (( $+commands[vim] )); then
    export EDITOR='vim'
fi

if (( $+commands[lsd] )); then
    alias ls='lsd'
fi
alias l='ls -lgt'
alias la='ls -a'
alias lla='ls -lgat'
alias lt='ls --tree -t'

if (( $+commands[just] )); then
    [[ ! -f "$ZCOMPLDIR/_just" ]] && just --completions zsh > "$ZCOMPLDIR/_just"
fi

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

autoload -Uz compinit bashcompinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
bashcompinit

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

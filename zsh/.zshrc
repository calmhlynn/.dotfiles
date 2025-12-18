# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
    starship
    rust
)


# Zellij
if [[ -x "$(command -v zellij)" ]]; then
  ZELLIJ_COMPLETION_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zellij"
  if [[ ! -d "$ZELLIJ_COMPLETION_DIR" ]]; then
    mkdir -p "$ZELLIJ_COMPLETION_DIR"
  fi

  if [[ ! -f "$ZELLIJ_COMPLETION_DIR/_zellij" || "$(zellij --version)" != "$(cat "$ZELLIJ_COMPLETION_DIR/.zellij_version" 2>/dev/null)" ]]; then
    zellij setup --generate-completion zsh > "$ZELLIJ_COMPLETION_DIR/_zellij"
    zellij --version > "$ZELLIJ_COMPLETION_DIR/.zellij_version"
  fi
  fpath=("$ZELLIJ_COMPLETION_DIR" $fpath)
  alias zj='zellij'

  function _zellij_tab_name_update() {
    if [[ -n "$ZELLIJ" ]]; then
      local dir_name="${PWD##*/}"
      [[ "$dir_name" == "$USER" ]] && dir_name="~"
      local tab_name="$dir_name"
      if [[ -n "$SSH_CONNECTION" ]]; then
        local host_name="${HOST%%.*}"
        tab_name="${host_name}:${dir_name}"
      fi
      command zellij action rename-tab "$tab_name" 2>/dev/null
    fi
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _zellij_tab_name_update
  _zellij_tab_name_update

  function ssh() {
    if [[ -n "$ZELLIJ" ]]; then
      local arg target_host
      # Heuristic: Find the last argument that doesn't start with '-'
      for arg in "$@"; do
        if [[ "$arg" != -* ]]; then
          target_host="$arg"
        fi
      done

      if [[ -n "$target_host" ]]; then
        command zellij action rename-tab "$target_host" 2>/dev/null
      fi

      command ssh "$@"
      local ret=$?

      # Restore the tab name
      _zellij_tab_name_update

      return $ret
    else
      command ssh "$@"
    fi
  }
fi

# Just
if [[ -x "$(command -v just)" ]];
then
  JUST_COMPLETION_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/just"
  if [[ ! -d "$JUST_COMPLETION_DIR" ]]; then
    mkdir -p "$JUST_COMPLETION_DIR"
  fi

  if [[ ! -f "$JUST_COMPLETION_DIR/_just" || "$(just --version)" != "$(cat "$JUST_COMPLETION_DIR/.just_version" 2>/dev/null)" ]]; then
    just --completions zsh > "$JUST_COMPLETION_DIR/_just"
    just --version > "$JUST_COMPLETION_DIR/.just_version"
  fi
  fpath=("$JUST_COMPLETION_DIR" $fpath)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#


if (( $+commands[lsd])); then
    alias ls='lsd'
fi
alias l='ls -lgt'
alias la='ls -a'
alias lla='ls -lgat'
alias lt='ls --tree -t'


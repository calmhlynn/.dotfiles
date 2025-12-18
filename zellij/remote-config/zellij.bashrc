if command -v zellij &> /dev/null; then
  eval "$(zellij setup --generate-completion bash)"
  alias zj='zellij'
  complete -F _zellij zj

  _zellij_tab_name_update() {
    if [[ -n "$ZELLIJ" ]]; then
      local dir_name="${PWD##*/}"
      [[ "$dir_name" == "$USER" ]] && dir_name="~"
      local tab_name="$dir_name"
      if [[ -n "$SSH_CONNECTION" ]]; then
        local host_name="${HOSTNAME%%.*}"
        tab_name="${host_name}:${dir_name}"
      fi
      command zellij action rename-tab "$tab_name" 2>/dev/null
    fi
  }
  PROMPT_COMMAND="_zellij_tab_name_update${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Default options
# ---------------
export FZF_DEFAULT_OPTS='--height 40% --border --info=inline'

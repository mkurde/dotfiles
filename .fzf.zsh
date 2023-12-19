# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX_ARM64}/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX_ARM64}/opt/fzf/shell/key-bindings.zsh"

# Default options
# ---------------
export FZF_DEFAULT_OPTS='--height 40% --border --info=inline'

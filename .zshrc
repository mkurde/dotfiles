# ------------------------------------------------------------------ agent detection
# Detect if running in Cursor agent mode to prevent terminal hangs
if [[ -n "$npm_config_yes" ]] || [[ -n "$CI" ]] || [[ "$-" != *i* ]]; then
  export AGENT_MODE=true
else
  export AGENT_MODE=false
fi

# ============================================================================
# MAIN CONFIGURATION SPLIT
# ============================================================================

if [[ "$AGENT_MODE" == "true" ]]; then
  # ===============================================
  # AGENT MODE - Minimal, fast, non-interactive
  # ===============================================

  # Simple prompt for agents
  PROMPT='%n@%m:%~%# '
  RPROMPT=''

  # Disable interactive features that can cause hangs
  unsetopt CORRECT
  unsetopt CORRECT_ALL
  setopt NO_BEEP
  setopt NO_HIST_BEEP
  setopt NO_LIST_BEEP

  # Set non-interactive environment variables
  export DEBIAN_FRONTEND=noninteractive
  export NONINTERACTIVE=1

  # Agent-friendly aliases to avoid interactive prompts
  alias cp='cp -f'
  alias mv='mv -f'
  alias npm='npm --no-fund --no-audit'
  alias yarn='yarn --non-interactive'
  alias pip='pip --quiet'

  # Load dotfiles (skip zsh_zstyles to avoid potential hangs)
  for file in ~/.{zsh_path,zsh_aliases,zsh_lib,zsh_functions,zsh_functions_mk,zsh_dockerfunc,zsh_extra}; do
      [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;

  # Load essential tools with error suppression
  eval "$(zoxide init zsh)" 2>/dev/null || true

else
  # ===============================================
  # NORMAL MODE - Full featured terminal experience
  # ===============================================

  # oh-my-zsh setup
  plugins=(brew copyfile copypath direnv git kubectl helm macos zsh-autosuggestions)
  fpath=($ZSH/custom/plugins/zsh-completions/src $fpath)
  source $ZSH/oh-my-zsh.sh

  # Load all dotfiles including zsh_zstyles
  for file in ~/.{zsh_path,zsh_aliases,zsh_lib,zsh_functions,zsh_functions_mk,zsh_dockerfunc,zsh_extra,zsh_zstyles}; do
      [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;

  # Load zoxide with full features
  eval "$(zoxide init zsh)"
  rm ~/.zcompdump*; compinit

  # Google Cloud SDK completions
  [ -f "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ] \
    && source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

  # Starship prompt
  if command -v starship > /dev/null ; then
    eval "$(starship init zsh)"
  fi
fi

# ============================================================================
# COMMON CONFIGURATION (both modes)
# ============================================================================

# Load fzf (works well in both modes)
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

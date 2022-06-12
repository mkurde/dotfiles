# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"
#!/usr/bin/env bash

# http://www.bash2zsh.com/

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerline"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="${HOME}/.zsh-custom"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew osx kubectl autojump)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------ sources

# direnv - https://direnv.net/
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# https://github.com/zsh-users/zsh-autosuggestions
[ -f '/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ] && source '/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh'

# https://github.com/zsh-users/zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# google-cloud-sdk PATH and completions
[ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ] \
	&& source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

[ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc ] \
	&& source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

# fix kubectl completion on zsh
source <( kubectl completion zsh | sed '/"-f"/d')

# brew install kube-ps1
if [ -f '/usr/local/opt/kube-ps1/share/kube-ps1.sh' ]; then
  source /usr/local/opt/kube-ps1/share/kube-ps1.sh
  KUBE_PS1_PREFIX=
  KUBE_PS1_SUFFIX=
  KUBE_PS1_SEPARATOR=' '
  KUBE_PS1_CTX_COLOR=cyan
  KUBE_PS1_NS_COLOR=blue
  PROMPT=$'\n''$(kube_ps1)'$PROMPT
fi

# NixOs
if [ -e /Users/mkurde/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/mkurde/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# https://github.com/nvm-sh/nvm
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/mkurde/.sdkman"
#[[ -s "/Users/mkurde/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/mkurde/.sdkman/bin/sdkman-init.sh"

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#eval $(thefuck --alias)

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"

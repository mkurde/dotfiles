# Path Loading Order
# https://medium.com/@rajsek/zsh-bash-startup-files-loading-order-bashrc-zshrc-etc-e30045652f2e
#~/.zshenv -> /etc/zprofile -> ~/.zprofile -> /etc/zshrc -> ~/.zshrc -> ~/.zlogin

# -------------------------------------------------------------------------- zsh

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="dsiebel"

# disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="${HOME}/.zsh-custom"

# -------------------------------------------------------------------------- env

# Setup homebrew env vars
# Note: PATH will be overwritten later
if [[ "$(/usr/bin/arch)" == "i386" ]]; then
	eval "$(/usr/local/bin/brew shellenv)"
else
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export HOMEBREW_PREFIX_X86="$(/usr/local/bin/brew --prefix)"
export HOMEBREW_PREFIX_ARM64="$(/opt/homebrew/bin/brew --prefix)"

# configure XDEBUG support
# export XDEBUG_CONFIG="idekey=XDEBUG";

# use vim as default editor for everything
export EDITOR="/usr/bin/vim";
export GIT_EDITOR=$EDITOR;
export SVN_EDITOR=$EDITOR;

# Terminal
export TERM="xterm-256color"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Prefer US English and use UTF-8
export LC_ALL='en_US.UTF-8';
export LANG='en_US.UTF-8';
export LC_LANG='en_US.UTF-8';

# Highlight section titles in man pages
export LESS_TERMCAP_md="${yellow}";

# Don't clear screen after quitting man page
export MANPAGER='less -X';
# export MANPATH="/usr/local/man:$MANPATH"

# setup java properly. Thanks, Steve!
export JAVA_HOME="$(/usr/libexec/java_home)";

# Golang $GOPATH.
export GOPATH="${HOME}/workspace"

# check for nvm and load it if present
#export NVM_DIR="/Users/dsiebel/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export GRADLE_USER_HOME="${HOME}/.gradle"

export GPG_TTY="$(tty)"

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Google Cloud
#export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json

# https://krew.sigs.k8s.io/docs/user-guide/advanced-configuration/
# used in `.path`
export KREW_ROOT="${HOME}/.krew"

# kubernetes dummy immage from Hendrik https://github.com/trivago/kubernetes-dummy-image
export KUBERNETES_DUMMY_IMAGE="${HOME}/workspace/src/github.com/trivago/kubernetes-dummy-image"

# https://github.com/sharkdp/fd
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

# kubectl
#export KUBECTL_EXTERNAL_DIFF="colordiff"

# zk notebook - https://github.com/mickael-menu/zk/blob/main/docs/config-alias.md
export ZK_NOTEBOOK_DIR="${HOME}/workspace/src/github.com/mkurde/zettelkasten/content"

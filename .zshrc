# -------------------------------------------------------------------- oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git brew osx sublime kubectl kube-ps1)
plugins=(brew copyfile copypath direnv git kubectl helm macos zsh-autosuggestions)

fpath=($ZSH/custom/plugins/zsh-completions/src $fpath)

source $ZSH/oh-my-zsh.sh

# ---------------------------------------------------------------- load dotfiles

# Load the shell dotfiles, and then some:
# * ~/.zsh_path         Extend `$PATH`. Always loaded last.
# * ~/.zsh_aliases      Shell aliases
# * ~/.zsh_lib          Library functions
# * ~/.zsh_functions    Helper functions
# * ~/.zsh_dockerfunc   Docker specific helper functions
# * ~/.zsh_extra        Other setting that MUST NOT be committed
# * ~/.zsh_styles       zstyle overwrites
for file in ~/.{zsh_path,zsh_aliases,zsh_lib,zsh_functions,zsh_dockerfunc,zsh_extra,zsh_zstyles}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# ----------------------------------------------------------- setup applications

# load fzf
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"

## load z - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"
rm ~/.zcompdump*; compinit

# google-cloud-sdk completions
[ -f "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ] \
	&& source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# https://starship.rs
if command -v starship > /dev/null ; then
	eval "$(starship init zsh)"
fi

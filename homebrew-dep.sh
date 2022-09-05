#!/usr/bin/env bash
set -e

brew bundle install --no-upgrade

# Switch to using brew-installed zsh as default shell
readonly zsh_path="$(command -v zsh)"
if ! grep -F -q "${zsh_path}" /etc/shells; then
  echo "${zsh_path}" | sudo tee -a /etc/shells;
  chsh -s "${zsh_path}";
fi;

# set iterm integration
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh \
 -o ~/.iterm2_shell_integration.zsh

# setup fzf
if ! command -v fzf > /dev/null; then
	$(brew --prefix)/opt/fzf/install --no-bash --no-fish \
 	--key-bindings --no-completion --update-rc
fi

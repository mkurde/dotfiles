# docs: https://github.com/casey/just/
# cheat-sheet: https://cheatography.com/linux-china/cheat-sheets/justfile/
# template: https://github.com/dsiebel/repository-template/blob/main/Justfile
set shell := ["bash", "-euo", "pipefail", "-c"]
set unstable
set script-interpreter := ['bash', '-euxo', 'pipefail']

_default:
	@just --list

# Installs everything
all: bin dotfiles macos vim homebrew-dep nix

# install bin directory files
[script]
bin:
	while IFS= read -r file; do
		f="$(basename "$file")"
		sudo ln -sf "$file" "/usr/local/bin/$f"
	done< <(find "{{ justfile_directory() }}/bin" -type f -not -name "meldDiff" -not -name ".*.swp" -not -name "vgaswitcheroo.sh")

# install the dotfiles for current user
[script]
dotfiles:
	git submodule init
	git submodule update

	while IFS= read -r file; do
		f="$(basename "${file}")"
		ln -sfn "${file}" "${HOME}/$f"
	done < <(find "{{ justfile_directory() }}" -type f -name ".*" -depth 1 -not -name ".git*" -not -name ".*.swp" -not -name ".gnupg")

	# special handling for .git* files to not mess with the repo
	while IFS= read -r file; do
		f="$(basename ${file})"
		ln -sfn "${file}" "${HOME}/${f/#dot/\.}"
	done< <(find {{ justfile_directory() }}/dotgit -name "dotgit*" -depth 1)

	# special handling for directories
	ln -sfn "{{ justfile_directory() }}/.oh-my-zsh" "${HOME}/.oh-my-zsh"
	ln -sfn "{{ justfile_directory() }}/.zsh-custom" "${HOME}/.zsh-custom"

	# we can not link the entire `.config` dir, it would only clutter up the git checkout
	mkdir -p "${HOME}/.config"
	ln -sfn "{{ justfile_directory() }}/.config/starship.toml" "${HOME}/.config/starship.toml"

	mkdir -p "${HOME}/.config/direnv"
	ln -sfn "{{ justfile_directory() }}/.config/direnv/direnv.toml" "${HOME}/.config/direnv/direnv.toml"
	ln -sfn "{{ justfile_directory() }}/.config/direnv/direnvrc" "${HOME}/.config/direnv/direnvrc"

	mkdir -p "${HOME}/.config/mise"
	ln -sfn "{{ justfile_directory() }}/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"

	# nushell reads Application Support on macOS, but ~/.config when XDG_CONFIG_HOME is set
	mkdir -p "${HOME}/.config/nushell" "${HOME}/Library/Application Support/nushell"
	ln -sfn "{{ justfile_directory() }}/.config/nushell/config.nu" "${HOME}/.config/nushell/config.nu"
	ln -sfn "{{ justfile_directory() }}/.config/nushell/config.nu" "${HOME}/Library/Application Support/nushell/config.nu"

	mkdir -p "${HOME}/.config/resticprofile"
	ln -sfn "{{ justfile_directory() }}/.config/resticprofile/profiles.yaml" "${HOME}/.config/resticprofile/profiles.yaml"
	ln -sfn "{{ justfile_directory() }}/.config/resticprofile/excludes.txt" "${HOME}/.config/resticprofile/excludes.txt"

	# ~/.ssh/config stays local (OrbStack and gcloud write to it) and includes this file
	mkdir -p "${HOME}/.ssh" && chmod 700 "${HOME}/.ssh"
	ln -sfn "{{ justfile_directory() }}/.ssh/dotfiles.config" "${HOME}/.ssh/dotfiles.config"

	# special handling for kubie config
	mkdir -p "${HOME}/.kube"
	ln -sfn "{{ justfile_directory() }}/.kube/kubie.yaml" "${HOME}/.kube/kubie.yaml"

	# k9s reads Application Support on macOS unless XDG_CONFIG_HOME is set
	mkdir -p "${HOME}/Library/Application Support/k9s"
	ln -sfn "{{ justfile_directory() }}/k9s/config.yaml" "${HOME}/Library/Application Support/k9s/config.yaml"
	ln -sfn "{{ justfile_directory() }}/k9s/aliases.yaml" "${HOME}/Library/Application Support/k9s/aliases.yaml"

# setup macos
macos:
	"{{ justfile_directory() }}/macos-defaults.sh"

# install amix/vimrc
vim:
	"{{ justfile_directory() }}/vim.sh"

# install homebrew
[script]
homebrew:
	if ! command -v brew; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

# install brews
homebrew-dep: homebrew
	"{{ justfile_directory() }}/homebrew-dep.sh"

# install fonts via homebrew
[script]
homebrew-fonts: homebrew
	brew bundle install --file "{{ justfile_directory() }}/Brewfile-fonts"

# install vscode extensions
vscode-ext:
	"{{ justfile_directory() }}/vscode/install-vscode-extensions" "{{ justfile_directory() }}/vscode/extensions.txt"

# install Determinate Nix and link /etc/nix/nix.custom.conf
[script]
nix:
	if [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
	fi
	sudo ln -sfn "{{ justfile_directory() }}/nix/nix.custom.conf" /etc/nix/nix.custom.conf
	sudo launchctl kickstart -k system/systems.determinate.nix-daemon

# set up kubectl plugins and completions
kubectl-setup:
	"{{ justfile_directory() }}/kubectl-setup.sh"

# Runs all the tests on the files in the repository.
test: shellcheck

# Runs the shellcheck tests on the scripts.
[script]
shellcheck:
	prek run --all-files shellcheck

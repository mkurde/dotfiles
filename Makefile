MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables

SHELL := bash
.SHELLFLAGS := -euo pipefail -c

DOCKER_FLAGS ?=

.ONESHELL:

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: bin dotfiles macos vim homebrew-dep ## Installs everything

.PHONY: bin
bin: ## install bin directory files
	for file in $(shell find $(CURDIR)/bin -type f -not -name "meldDiff" -not -name ".*.swp" -not -name "vgaswitcheroo.sh"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done
	# Hack to make git reup, git ffup work as well
	# TODO: come up with a better solution
	sudo ln -sf /usr/local/bin/git-up /usr/local/bin/git-reup
	sudo ln -sf /usr/local/bin/git-up /usr/local/bin/git-ffup

.PHONY: dotfiles
dotfiles: ## install the dotfiles for current user
	git submodule init
	git submodule update

	for file in $(shell find $(CURDIR) -type f -name ".*" -depth 1 -not -name ".git*" -not -name ".travis.yml" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $${file}); \
		ln -sfn $$file $${HOME}/$$f; \
	done; \

	# special handling for .git* files to not mess with the repo
	for gitfile in $(shell find $(CURDIR)/dotgit -name "dotgit*" -depth 1); do \
		f=$$(basename $${gitfile}); \
		ln -sfn $$gitfile $${HOME}/$${f/#dot/\.}; \
	done;

	# special handling for directories
	ln -sfn $(CURDIR)/.oh-my-zsh $${HOME}/.oh-my-zsh;
	ln -sfn $(CURDIR)/.zsh-custom $${HOME}/.zsh-custom;

	# we can not link the entire `.config` dir, it would only clutter up the git checkout
	mkdir -p $${HOME}/.config
	ln -sfn $(CURDIR)/.config/starship.toml $${HOME}/.config/starship.toml;

	# special handling for kubie config
	mkdir -p $${HOME}/.kube
	ln -sfn $(CURDIR)/.kube/kubie.yaml $${HOME}/.kube/kubie.yaml;

.PHONY: macos
macos: ## setup macos
	$(CURDIR)/macos.sh

.PHONY: vim
vim: ## install amix/vimrc
	$(CURDIR)/vim.sh

.PHONY: homebrew
homebrew: ## install homebrew
	if ! command -v brew; then \
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
	fi

.PHONY: homebrew-dep
homebrew-dep: homebrew ## install brews
	$(CURDIR)/homebrew-dep.sh

.PHONY: homebrew-fonts
homebrew-fonts: homebrew ## install brews
	brew bundle install --file $(CURDIR)/Brewfile-fonts

.PHONY: vscode-ext
vscode-ext:
	$(CURDIR)/vscode/install-vscode-extensions $(CURDIR)/vscode/extensions.txt

#DOCKER_MACHINE_NAME ?= default
#
#.PHONY: docker-machine
#docker-machine: ## set up docker-machine. Use DOCKER_MACHINE_NAME to overwrite machine name
#	$(CURDIR)/docker-machine.sh $(DOCKER_MACHINE_NAME)

.PHONY: test
test: shellcheck ## Runs all the tests on the files in the repository.

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [[ -t 0 ]] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += --tty
endif

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm --interactive $(DOCKER_FLAGS) \
		--name df-shellcheck \
		--volume $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		--entrypoint ./test.sh \
		dsiebel/shellcheck-docker

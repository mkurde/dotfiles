# Agent notes

Personal macOS dotfiles. `just --list` is the installer. `README.md` is
the human setup path.

## Why a change exists

Read `CHANGELOG.md` before touching zsh startup, completions, or iTerm
prompt hooks. Those entries are small ADRs. Add one when the "why"
would not be obvious from the diff.

## zsh

Load order is in the header of `.zshenv`. Interactive extras live in
`.zshrc` behind `AGENT_MODE`. Keep `zoxide init` last.

oh-my-zsh already runs `compinit`. If a new completion is missing, run
`rm ~/.zcompdump*; compinit` once in that session.

`iterm2_print_user_vars` in `.zsh_functions` caches kubectl until the
kubeconfig mtime changes. Keep that cache if you edit iTerm user vars.

## Where code belongs

Local shell behaviour goes in `.zshrc` and `~/.zsh_*` (this repo).
oh-my-zsh and `.zsh-custom` plugins are vendored; change them only when
the behaviour cannot live in those local files.

`just dotfiles` is how files get linked into `$HOME`.

## No employer specifics

This repo is public and personal. Keep employer specifics out of it:
org names, internal repos and tools, hostnames, clusters, ticket IDs.
That covers code, comments, CHANGELOG and commit messages. Check with
`git diff --cached | grep -i <employer>` before committing.

Employer config lives in the private work repo and gets linked into a
drop-in directory that this repo already loads. Example: work tools
for mise go in `~/.config/mise/conf.d/*.toml`, not in
`.config/mise/config.toml`. If no drop-in point exists, add a generic
one (e.g. source `~/.zshrc.local` if present) rather than the specific.

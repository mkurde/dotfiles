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

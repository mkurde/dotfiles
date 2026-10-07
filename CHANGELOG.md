# Changelog

Short ADRs for non-obvious dotfile changes. Newest first.

Each entry answers: what was going on, what we chose, and why that
choice exists so a future me does not "fix" it back.

## 2026-10-06: `just macos` runs `macos-defaults.sh`

### Context

`macos.sh` was the 950-line mathiasbynens `.macos`. Most of it targets
apps or features that no longer exist (Dashboard, Twitter.app, iCal,
Spotlight `orderedItems`). Before migrating to a new MacBook it was hard
to tell which lines still mattered.

### Split into `macos-defaults.sh` and `macos-legacy.sh`

- **Decision:** `macos.sh` is renamed to `macos-legacy.sh` and is no
  longer run. `macos-defaults.sh` is dsiebel's short list, with my
  values where they differ, plus the legacy settings I still use. The
  iTerm `PromptOnQuit` and `OpenBookmark` pins moved with it.
- **Why:** A short, current script is easier to review on a fresh
  machine. Mine differs from dsiebel's on purpose: software updates
  stay on, scroll bars `Always`, column view, font smoothing `2`, and
  `hibernatemode 3`. Keep `hibernatemode 3` without his `sleepimage`
  removal, because mode 3 writes RAM to that file.
- Settings not carried over (Spotlight index rebuild, `LSQuarantine`
  off, Mail, Chrome, App Store debug menus) stay in `macos-legacy.sh`
  for reference.

## 2026-09-21: iTerm Profiles window on every launch

### Context

iTerm opened the Profiles picker at startup. The default profile
(`Default mkurde`) was still set. `OpenBookmark` in
`com.googlecode.iterm2` was `1`, which is Settings → General → Startup
"open the profiles window". Not from this repo. Easy to tick while
editing profiles, and a new Mac would not inherit the UI uncheck.

### Pin `OpenBookmark` in `macos.sh`

- **Decision:** `defaults write com.googlecode.iterm2 OpenBookmark -bool false`
  next to `PromptOnQuit`.
- **Why:** `just macos` is the reinstall path for a new machine. iTerm
  rewrites its plist on quit, so this only sticks if iTerm is not
  running when `macos.sh` runs, which is true on a fresh setup.

## 2026-09-21: iTerm / zsh felt like it launched a pile of apps

### Context

New iTerm tabs spent ~1.5s before the prompt was usable. `zprof` and
`zsh -xvic` showed two separate costs, not one mysterious iTerm
setting.

### Drop `rm ~/.zcompdump*; compinit` from `.zshrc`

- **Decision:** Let oh-my-zsh own the dump. Do not delete it every
  interactive shell.
- **Why:** The line was added in 2022 next to `zoxide init` so the `z`
  completion would show up after oh-my-zsh had already run
  `compinit`. That is a one-shot fix after adding completions, not a
  startup ritual. In 2025 zoxide moved to the end of `.zshrc` and the
  `rm` stayed behind as "Refresh completions". oh-my-zsh already
  rebuilds the dump when its revision or `fpath` stamp is stale. The
  extra `rm` made `compinit` run twice on every tab (~150k xtrace
  lines). If a new completion is missing, run
  `rm ~/.zcompdump*; compinit` once by hand.

### Cache kubectl in `iterm2_print_user_vars`

- **Decision:** Remember context and namespace until the kubeconfig
  mtime changes. Use `zstat` for that check. Keep sending `pwd` from
  `$PWD`.
- **Why:** iTerm calls this on every precmd. The old function forked
  `kubectl config current-context` and `kubectl config view --minify`
  each time (~1.5s self time in `zprof`). Context only changes when
  the kubeconfig does, so those forks were wasted. First prompt of a
  session still pays kubectl; later prompts should not.

Profiling notes (`zmodload zsh/zprof`, dump to
`~/workspace/src/tmp/zprof`, `zsh-startup-trace.log`) were throwaway
and are not in this repo.

# Changelog

Short ADRs for non-obvious dotfile changes. Newest first.

Each entry answers: what was going on, what we chose, and why that
choice exists so a future me does not "fix" it back.

## 2026-11-02: Nix cache for Emanote moves to nixos.asia

### Context

`cache.garnix.io` stopped resolving (NXDOMAIN on every resolver), so
every Nix call retried it five times. Emanote upstream switched its
`nixConfig` to `cache.nixos.asia/oss`. nixpkgs dropped `emanote`, so
`cache.nixos.org` has no prebuilt copy.

### Swap the substituter in `nix/nix.custom.conf`

- **Decision:** Replace garnix with `https://cache.nixos.asia/oss`
  and its `oss:` key. Bump the emanote input in repos that use it.
- **Why:** It is the cache Emanote upstream names, and the dead
  garnix host made every Nix call slow. On 2026-11-02 it had no
  `aarch64-darwin` build of Emanote, so the first build on a Mac still
  compiles Haskell from source (once, until the next `nix store gc`).
  Apply with
  `sudo launchctl kickstart -k system/systems.determinate.nix-daemon`
  (the file is a symlink, so no re-link needed).

## 2026-11-02: git identity in `~/.gitconfig.local`

### Context

`dotgit/dotgitconfig` hardcoded the work email and GPG signing key.
On the private Mac that key does not exist, so every signed commit
failed, and the work email does not belong in this repo.

### Include a per-machine file

- **Decision:** Keep only `user.name` in the tracked config. Include
  `~/.gitconfig.local` at the end for `user.email`, `user.signingkey`
  and `gpg.format`. The work Mac gets its file from the work repo.
- **Why:** One repo, two identities, no employer details. The include
  is last so the local file wins.

### SSH signing on the private Mac

- **Decision:** `gpg.format = ssh` with the GitHub SSH key as signing
  key, registered on GitHub as a signing key.
- **Why:** The key is already in the Keychain; no GnuPG keyring,
  agent or pinentry to carry around.

## 2026-10-29: gcloud runs on mise Python

### Context

The gcloud cask depends on Homebrew `python@3.14` and builds its
virtualenv on it. A brew upgrade relinked that Python against
`openssl@4`, which has no `ssl.PROTOCOL_TLSv1`. gcloud's vendored
urllib3 still uses it, so `gcloud storage` crashed on import.

### `CLOUDSDK_PYTHON` in `.zshenv`

- **Decision:** Point `CLOUDSDK_PYTHON` at the mise `python/3.12`
  symlink and delete the gcloud virtualenv
  (`gcloud config virtualenv delete`).
- **Why:** mise Python bundles its own OpenSSL 3, so brew Python or
  OpenSSL bumps no longer change gcloud's runtime. The `3.12` symlink
  survives patch upgrades. Drop this once gcloud supports OpenSSL 4.

### Ignore the `update-macos-python` warning

- **Decision:** `report_issues` drops the warning `gcloud components
  update` prints about `update-macos-python`.
- **Why:** That step rebuilds the virtualenv on brew `python@3.14`
  (still OpenSSL 4) on every update. `CLOUDSDK_PYTHON` bypasses that
  virtualenv, so the warning is noise. Re-running the command only
  recreates the unused virtualenv.

## 2026-10-22: Touch ID for sudo via `sudo_local`

### Context

`pam.d/sudo` patched `/etc/pam.d/sudo` with `pam_tid.so`. That file is
reset by macOS updates. Sequoia already `include`s `sudo_local` for
local overrides.

### Ship `sudo_local`, not `sudo`

- **Decision:** Track `pam.d/sudo_local` (only the `pam_tid` line) and
  install it with `just pam`, which `just macos` runs first.
- **Why:** Matches Apple's template path, survives updates, and leaves
  the system `sudo` PAM stack alone.

## 2026-10-20: Brewfile trusts third-party formulae

### Context

`just homebrew-dep` on a fresh Mac stopped and asked for
`brew trust` on sofka, redpanda and nats. Homebrew 6 (June 2026)
refuses to load a non-official tap until that formula or cask is
trusted. An existing Mac already had them installed, so the prompt
never showed up there.

### `trusted: true` on the six tap packages

- **Decision:** Mark nats, redpanda, sofka, myks, opensuperwhisper
  and orca `trusted: true`. Leave the taps themselves untrusted.
- **Why:** `brew bundle` records that trust before it installs, so a
  fresh run does not stop. Item trust is enough; the rest of each tap
  stays unloaded. `brew bundle cleanup` also resets the trust store to
  whatever the Brewfile declares, so the marks have to live here.

## 2026-10-13: daily updates claim the day with `mkdir`

### Context

After the Mac migration, iTerm restored four tabs in the same second.
All four shells passed the date check before any of them wrote
`last-update-date`, so four brew runs shared one cache. The results
were signature mismatches, half-downloaded DMGs, Cellar locks and a
broken BetterTouchTool rollback.

- **Decision:** `mkdir run-<date>` in the lock dir claims the day. The
  date file stays for `daily-updates-status`.
- **Why:** `mkdir` is atomic, so exactly one shell wins. A date in the
  directory name means a shell killed mid-run cannot block later days,
  so there is no stale-PID handling.

### mise instead of `bin` for CLI tools

- **Decision:** kubent is in the global mise config (skaffold already
  was). Work tools go in `~/.config/mise/conf.d/`, linked from a private
  work repo. The daily run calls `mise -C ~ upgrade` as a logged step.
  `bin` and its fast-update loop are gone.
- **Why:** `bin` was not installed on the new Mac and needed its own
  token handling. mise already gets a token from `gh auth token` for
  private repos, and the upgrade stays inside the version pins.
  `-C ~` keeps the current project's `mise.toml` out of the upgrade.

## 2026-10-08: tooling updates skip in-use casks, log parsed as bytes

### Context

A gcloud update killed mid-progress-bar left half a UTF-8 char in
`slow-updates.log`. The `Error:` marker was glued onto it, and macOS awk
then aborted with `towc: multibyte conversion failure`. The issue report
showed nothing at all. Separately, daily runs broke live Claude Code /
Cursor / VS Code sessions. A weekly schedule was considered; updates stay
daily while the in-use check below is tried first.

### Skip casks with a running binary

- **Decision:** Before `brew upgrade --cask`, `lsof -d txt` lists the
  Caskroom paths of running executables, and those casks are skipped.
  The run prints the manual `brew upgrade --cask` command for them.
  `CASK_UPGRADE_EXCLUDE` stays for GUI apps in `/Applications`.
- **Why:** The static exclude only covered `visual-studio-code` and
  `cursor`. The CLI casks (`claude-code@latest`, `cursor-cli`,
  `copilot-cli`) kept upgrading, and an upgrade deletes the old
  `Caskroom/<cask>/<version>/` that running sessions still use.

### `LC_ALL=C` for `tr`, `awk`, `grep` on tool output

- **Decision:** Byte locale for the log pipeline. The failure marker is
  written on a fresh line when the step output ends without a newline.
- **Why:** Tool output is not guaranteed to be valid UTF-8. In a UTF-8
  locale `tr` drops everything after a bad byte and awk aborts. Both
  hide the errors the report exists to show.

## 2026-10-07: prek instead of pre-commit, no git template dir

### Context

`init.templateDir` pointed at `~/.git-template`, a hook generated by
`pre-commit init-templatedir` that hardcodes Homebrew's Python path.
That path breaks on a new Mac. `prek` was already a global mise tool.
Follows dsiebel/dotfiles `ed932d0` and `c85eb3c`.

### Repo `mise.toml` installs the hook

- **Decision:** Drop `templateDir` and `brew "pre-commit"`. The repo
  `mise.toml` installs `prek` and runs `prek install` as a postinstall
  hook. `just shellcheck` calls `prek`.
- **Why:** Hooks get installed per repo, by the tool that runs them,
  instead of copied into every clone from a stale template.

### No fzf installer in `homebrew-dep.sh`

- **Decision:** Removed the `fzf/install --update-rc` call.
- **Why:** `.fzf.zsh` is in this repo and `.zshrc` sources it. The
  installer would overwrite the linked file and append to `.zshrc`,
  which means writing into the repo. The old `command -v fzf` guard
  only hid this because brew had just installed fzf.

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

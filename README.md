# dotfiles

My .files.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew](https://brew.sh/) to install things like Chrome and 1Password and stuff.
- **topic/\*.zsh**: Any files starting with `.zsh` get loaded into your environment.

## Install

Requires [just](https://github.com/casey/just), installed via mise from the
repo `mise.toml` (not via Homebrew). Run `just` to list all recipes.

Bootstrap on a fresh Mac:

```bash
xcode-select --install
git clone https://github.com/mkurde/dotfiles.git ~/workspace/src/github.com/mkurde/dotfiles
cd ~/workspace/src/github.com/mkurde/dotfiles
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install mise
mise trust && mise install
eval "$(mise activate bash)"
```

Setup steps (order):

- `just homebrew-dep`
- restore the `config` backup (SSH keys and `~/.ssh/config`, GnuPG, kube),
  see [Backup](#backup)
- `just dotfiles`, also checks out the submodules (oh-my-zsh, zsh plugins)
  over HTTPS. Update them with `git submodule update --remote` and commit
  the new pointers.
- `just macos`
- `just vim`
- `just bin`
- `just nix`, see [Nix](#nix)
- optional: `just homebrew-fonts`
- optional: `just vscode-ext`
- optional: `just kubectl-setup`

Or everything at once: `just all`

The repo is public, so cloning over HTTPS works before any SSH key exists.
Switch to SSH afterwards:
`git remote set-url origin git@github.com:mkurde/dotfiles.git`.

## Nix

Repos with a `flake.nix` and `use flake` in `.envrc` need Nix.

[Determinate Nix](https://docs.determinate.systems), installed by `just nix`.
It also links `nix/nix.custom.conf` (trusted users, garnix cache for prebuilt
Emanote) to `/etc/nix/nix.custom.conf` and restarts the daemon.

The PATH entry is in `.zsh_path`, nix-direnv is loaded by
`.config/direnv/direnvrc` (both linked by `just dotfiles`). Run `direnv allow`
once per repo; the first run builds the dev shell.

Update: `sudo determinate-nixd upgrade`.

## SSH

`~/.ssh/config` stays a local file, because OrbStack and
`gcloud compute config-ssh` write to it. It starts with:

```text
Include ~/.orbstack/ssh/config
Include ~/.ssh/dotfiles.config
```

`.ssh/dotfiles.config` (linked by `just dotfiles`) holds only the shared
`Host *` defaults. Host entries and `IdentityFile` lines stay in the local
file, because this repo is public.

## Backup

[resticprofile](https://creativeprojects.github.io/resticprofile/) with the
config in `.config/resticprofile/`. The repository lives on the external drive
under `/Volumes/Samsung_T5/restic/<hostname>`; the password is in 1Password.

```bash
resticprofile full.backup        # all profiles
resticprofile config.snapshots   # list snapshots
```

To restore on a Mac with a different hostname, use plain `restic` against the
old repository:

```bash
restic -r /Volumes/Samsung_T5/restic/<old-hostname> --password-file <file> \
  restore latest --tag config --target /tmp/restore
```

## Not automated (yet)

Here is a list of things i need to do if i set up a new machine (aka my .files TODO list):

- VSCode: Settings + Plugins

## Inspired by

The content of this repository was heavily inspired by

- [dsiebel/dotfiles](https://github.com/dsiebel/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [dotfiles.github.io](https://dotfiles.github.io/)

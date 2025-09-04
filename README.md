# dotfiles

My .files.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew](https://brew.sh/) to install things like Chrome and 1Password and stuff.
- **topic/\*.zsh**: Any files starting with `.zsh` get loaded into your environment.

## Install

check Makefile

## Before reinstallation

- Backup:
  - `.ssh` SSH-Keys
  - `.gnupg` Gnu GPG for Blackbox or GitHub Signing
  - `.localrc`

## Not automated (yet)

Here is a list of things i need to do if i set up a new machine (aka my .files TODO list):

- VSCode: Settings + Plugins
- Install of software:
  - Microsoft Office
  - Pages, Numbers and Keynote
  - Magnet
- Handling of SSH keys, the `.localrc`

## Inspired by

The content of this repository was heavily inspired by

- [dsiebel/dotfiles](https://github.com/dsiebel/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [dotfiles.github.io](https://dotfiles.github.io/)

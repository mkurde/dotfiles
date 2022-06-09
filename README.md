# dotfiles

My .files.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew](https://brew.sh/) to install things like Chrome and 1Password and stuff.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## Install

tbd

## Before reinstallation

* Backup:
	* SSH-Keys
	* `.localrc`

## Not automated (yet)

Here is a list of things i need to do if i set up a new machine (aka my .files TODO list):

* VSCode: Settings + Plugins
* Install of software:
    * Microsoft Office
    * Pages, Numbers and Keynote
    * Magnet
* Handling of SSH keys, the `.localrc`

## Inspired by ...

The content of this repository was heavily inspired by

* [dsiebel/dotfiles](https://github.com/dsiebel/dotfiles)
* [holman/dotfiles](https://github.com/holman/dotfiles)
* [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
* [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
* [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
* [dotfiles.github.io](https://dotfiles.github.io/)

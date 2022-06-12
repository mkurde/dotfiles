# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zprofile.pre.zsh"
#!/usr/bin/env bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{zsh_zstyles,zsh_path,zsh_exports,zsh_aliases,zsh_functions,zsh_dockerfunc,zsh_extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zprofile.post.zsh"

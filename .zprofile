# Load the shell dotfiles, and then some:
# # * ~/.path can be used to extend `$PATH`.
# # * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{zsh_path,zsh_exports,zsh_aliases,zsh_functions,zsh_dockerfunc,zsh_extra,zsh_zstyles}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

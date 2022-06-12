# Working with git submodules

## Documentation

Blog <https://www.vogella.com/tutorials/GitSubmodules/article.html>
Official Git chapter: <https://git-scm.com/book/en/v2/Git-Tools-Submodules>

## Adding a submodule

Initial commands to add .oh-my-zsh

```sh
# add .oh-my-zsh
git submodule add git@github.com:ohmyzsh/ohmyzsh.git .oh-my-zsh

# add zsh syntax highlighting
git submodule add https://github.com/zsh-users/zsh-syntax-highlighting.git .zsh-custom/plugins/zsh-syntax-highlighting

# add zsh autocomplete
git submodule add git@github.com:zsh-users/zsh-completions.git .zsh-custom/plugins/zsh-completions
```

## Update submodules

```bash
# Go to the submodule directory, do note the example is named naively for the purpose of demonstration
$ cd example_submodule_directory

# Check out desired branch
$ git checkout master
$ git pull

# Go back to your project root, your tree structure might be deeper, so this is just a basic example
$ cd ..

# Now you can commit these changes to your project
$ git commit -am "Pulled down update to submodule: example (example_submodule_directory)"
```

## References

- [Stack
  Overflow](https://stackoverflow.com/questions/5828324/update-git-submodule-to-latest-commit-on-origin)

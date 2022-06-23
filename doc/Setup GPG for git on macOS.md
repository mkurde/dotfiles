# Setup GPG for git on macOS

## Install GnuPG

On MacOS

```sh
  brew install gnupg pinentry-mac
  echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
  export GPG_TTY=$(tty) # to work around bug (keybase/keybase-issues#2798)
  killall gpg-agent
```

## Generate GPG Key

```sh
# Generate Key

gpg --full-generate-key
```

```sh
# Checking my key

gpg --list-secret-keys --keyid-format=long
/Users/hubot/.gnupg/secring.gpg
------------------------------------
sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
uid                          Hubot 
ssb   4096R/42B317FD4BA89E7A 2016-03-10
```

```sh
# Copying key

gpg --armor --export 3AA5C34371567BD2 | pbcopy
```

Testing the default key:

```sh
echo "test" | gpg --clearsign
```

## Modify .gitconfig to sign git commits

To set your GPG signing key in Git, paste the text below, substituting in the
GPG key ID you'd like to use. In this example, the GPG key ID is
3AA5C34371567BD2 (ID in the line starting with "sec"):

```sh
git config --global user.signingkey 3AA5C34371567BD2
```

or edit your .gitconfig and add in the `[user]` section

```text
[user]
  name = foo bar
  email = foo.bar@gmail.com
  signingkey = 3AA5C34371567BD2
```

## Backup and restore

```sh
gpg --export-secret-keys KEY_ID > my-private-key.asc
gpg --import my-private-key.asc
```

## Reference

- <https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>
- <https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key>
- <https://medium.com/@jma/setup-gpg-for-git-on-macos-4ad69e8d3733>
- <https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits>

## Troubleshooting

https://stackoverflow.com/questions/39494631/gpg-failed-to-sign-the-data-fatal-failed-to-write-commit-object-git-2-10-0

# Touch ID for sudo

macOS includes `sudo_local` from `/etc/pam.d/sudo`. Put Touch ID there so
OS updates do not wipe it (they reset `/etc/pam.d/sudo`).

```sh
just pam
```

That installs `pam.d/sudo_local` to `/etc/pam.d/sudo_local`. Test with
`sudo -k && sudo -v`.

Password still works if Touch ID fails or is unavailable (lid closed,
tmux without `pam_reattach`, DisplayLink without `ignoreArd`).

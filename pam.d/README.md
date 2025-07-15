---
date: 2022-09-13
tags:
  - "pam.d"
  - "sudo"

---

# Enable TouchID for sudo in iTerm2 and iTerm3

Source: <https://antkowiak.it/en/enable-touchid-for-sudo-in-iterm-2/>

1. Open in text editor file `/etc/pam.d/sudo`

    ```sh
    sudo vim /etc/pam.d/sudo

    # add (at the top) line:
    auth sufficient pam_tid.so
    ```

2. Go to iTerm (**iTerm2 -> Preferences…**) – or use shortcut *cmd and comma* (`⌘,`)
   in the Advanced tab scroll to the category **Session** and change *Allow
   sessions to survive logging out and back in.* to **No**.

   iTem2 Preference Menu
   ![iTerm2 Preference Menu](resources/images/iterm2_preference.png)
  
   iTerm2 Preference - Advance Menu
   ![iTerm2 Preference Advance Menu](resources/images/iterm2_preference_advanced.png)

# Dotfiles

This should be cloned to ~/dotfiles.

```sh
git clone https://github.com/LikeCarter/dotfiles ~/
./install.sh
```

Generate a GPG key and start signing git commits:

```
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey xxxxxxxxxxxxxxxx
git config --global commit.gpgsign true
```

# Manual

## Chrome extensions

- uBlock Origin
- 1Password

## App store

- Magnet.app

## iTerm2

By default, word jumps (option + → or ←) and word deletions (option + backspace) do not work.

To enable these: go to iTerm → Preferences → Profiles → Keys → Presets... → Natural Text Editing.
You may also set (ctrl + b or ctrl + f) for word jumps and word deletions (ctrl + w).

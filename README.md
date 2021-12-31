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

## MacOS App Store

We install the following via `mas` cli:

- Tailscale.app
- Magnet.app

## Brew

We install the following via `brew` cli:

- gnu-sed
- etc.

# Manual

## Chrome extensions

- uBlock Origin
- 1Password

## iTerm2

By default, word jumps (option + → or ←) and word deletions (option + backspace) do not work.

To enable these: go to iTerm → Preferences → Profiles → Keys → Presets... → Natural Text Editing.
You may also set (ctrl + b or ctrl + f) for word jumps and word deletions (ctrl + w).

### TODO

Setup iterm2 theme automagically...
Setup GPG signing key automagically...
Setup keyboard shortcuts automagically...
Setup vscode extensions + settings automagically...

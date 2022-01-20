# Dotfiles

This should be cloned to ~/dotfiles.

```sh
cd ~
git clone https://github.com/LikeCarter/dotfiles
./dotfiles/install.sh
```

### **Add Git GPG Key**

```
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey xxxxxxxxxxxxxxxx
git config --global commit.gpgsign true
```

### **Add Jetbrains Mono to Visual Studio Code**

1. From the **File** menu (**Code** on Mac) go to `Preferences` → `Settings, or use keyboard shortcut <kbd>Ctrl</kbd>+<kbd>,</kbd> (<kbd>Cmd</kbd>+<kbd>,</kbd> on Mac).
2. In the E**ditor: Font Family** input box type `JetBrains Mono`, replacing any content.
3. To enable ligatures, go to **Editor: Font Ligatures**, click **Edit in settings.json**, and copy this line `"editor.fontLigatures": true` into json file.

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

## License

[MIT](https://opensource.org/licenses/MIT)

## Author

Carter Sprigings

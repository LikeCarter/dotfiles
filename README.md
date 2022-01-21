# Dotfiles

## Setup

This repository should be cloned to ~/dotfiles.

```sh
cd ~
git clone https://github.com/LikeCarter/dotfiles
./dotfiles/install.sh
```

## Optional

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


## Guides

[iTerm2 Shortcuts](https://gist.github.com/squarism/ae3613daf5c01a98ba3a#file-iterm2-md)

## License

[MIT](https://opensource.org/licenses/MIT)

## Author

Carter Sprigings

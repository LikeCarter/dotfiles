# Dotfiles

## Setup

This repository should be cloned to ~/dotfiles.

```sh
cd ~
git clone https://github.com/LikeCarter/dotfiles
./dotfiles/install.sh
```

## Optional

### **Add git signing**

```
brew install gpg2 gnupg pinentry-mac       
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
chmod 700 ~/.gnupg
killall gpg-agent
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global gpg.program $(which gpg)

gpg --full-generate-key
gpg -K --keyid-format SHORT
# sec rsa4096/######## YYYY-MM-DD [SC] [expires: YYYY-MM-DD]
git config --global user.signingkey ########
gpg --armor --export ########
```

Login into Github.com and go to your settings, SSH and GPG Keys, and add your GPG key from the page.


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

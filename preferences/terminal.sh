# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Jump To A Directory That Contains foo:

# j foo
# Jump To A Child Directory:
# Sometimes it's convenient to jump to a child directory (sub-directory of current directory) rather than typing out the full name.
# jc bar
# Open File Manager To Directories (instead of jumping):
# jo music
brew install autojump

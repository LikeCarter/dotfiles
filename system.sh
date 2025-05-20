# ------------------------------------------------------------
# Terminal
# ------------------------------------------------------------

# Only use UTF-8 in Terminal.app
sudo defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
sudo defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
sudo defaults write com.apple.Terminal ShowLineMarks -int 0

# Don’t display the annoying prompt when quitting iTerm
sudo defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Enable alternate mouse scroll
sudo defaults write com.googlecode.iterm2 AlternateMouseScroll -bool true

# Jump To A Directory That Contains foo:

# Define the required keybindings
KEYBINDINGS='
"\C-b": backward-word
"\C-f": forward-word
"\e\C-f": forward-word
'

# Check if ~/.inputrc exists
if [ ! -f ~/.inputrc ]; then
    echo "Creating ~/.inputrc"
    touch ~/.inputrc
fi

# Append keybindings if they are not already present
echo "$KEYBINDINGS" | while read -r line; do
    if ! grep -Fxq "$line" ~/.inputrc; then
        echo "$line" >> ~/.inputrc
    fi
done


# ------------------------------------------------------------
# VSCode
# ------------------------------------------------------------

# Fix key repeat in vs code. I don't use it that often, but this is necessary when I do
sudo defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false

# ------------------------------------------------------------
# System
# ------------------------------------------------------------

# Expand save panel by default
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Automatically quit printer app once the print jobs complete
sudo defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Save to disk (not to iCloud) by default
sudo defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand print panel by default
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable automatic capitalization as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
sudo defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad: enable tap to click for this user and for the login screen
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Increase sound quality for Bluetooth headphones/headsets
sudo defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
sudo defaults write com.apple.screencapture type -string "png"

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
sudo defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
sudo defaults write com.apple.finder QuitMenuItem -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
sudo defaults write com.apple.finder NewWindowTarget -string "PfDe"
sudo defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show icons for hard drives, servers, and removable media on the desktop
sudo defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
sudo defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
sudo defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
sudo defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
sudo defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
sudo defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
sudo defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
sudo defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Enable the debug menu in Address Book
sudo defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Use plain text mode for new TextEdit documents
sudo defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
sudo defaults write com.apple.TextEdit PlainTextEncoding -int 4
sudo defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
sudo defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
sudo defaults write com.apple.DiskUtility advanced-image-options -bool true

# Auto-play videos when opened with QuickTime Player
sudo defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# Enable the firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable auto-correct
sudo defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show batter percentage
sudo defaults write com.apple.menuextra.battery ShowPercent -bool true

# Show the date in the toolbar
sudo defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm'

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable sound effects when changing volume
sudo defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0

# Disable sounds effects for user interface changes
sudo defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Set alert volume to 0
sudo defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.0

# Show volume in the menu bar
sudo defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -int 0

# Show Bluetooth in the menu bar
sudo defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -int 0

# Avoid creating .DS_Store files on network or USB volumes
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't hide files
sudo defaults write com.apple.Finder AppleShowAllFiles true

# Speed up window opening by disabling animation
sudo defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# Prevent Time Machine from prompting to use new hard drives as backup volume
sudo defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Remove text replacements
sudo defaults write -g NSUserDictionaryReplacementItems -array

# Disable internet search in spotlight
sudo defaults write com.apple.Spotlight SuggestionsEnabled -bool false
sudo defaults write com.apple.Spotlight SuggestionsDisabled -bool true
sudo defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true
sudo defaults write com.apple.Siri SiriSuggestionsEnabled -bool false

# ------------------------------------------------------------
# Photos
# ------------------------------------------------------------

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


# ------------------------------------------------------------
# Safari
# ------------------------------------------------------------

# Privacy: don’t send search queries to Apple
sudo defaults write com.apple.Safari UniversalSearchEnabled -bool false
sudo defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
sudo defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
sudo defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable Safari’s debug menu
sudo defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Warn about fraudulent websites
sudo defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
sudo defaults write com.apple.Safari WebKitPluginsEnabled -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
sudo defaults write com.apple.Safari WebKitJavaEnabled -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
sudo defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
sudo defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
sudo defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true


# ------------------------------------------------------------
# Mail
# ------------------------------------------------------------
# Disable send and reply animations in Mail.app
sudo defaults write com.apple.mail DisableReplyAnimations -bool true
sudo defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
sudo defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
sudo defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Disable inline attachments (just show the icons)
sudo defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
sudo defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

# ------------------------------------------------------------
# iMessage
# ------------------------------------------------------------
# Disable automatic emoji substitution (i.e. use plain text smileys)
sudo defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
sudo defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
sudo defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

# ------------------------------------------------------------
# Chrome
# ------------------------------------------------------------

# Disable the all too sensitive backswipe on trackpads
sudo defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
sudo defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
sudo defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
sudo defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
sudo defaults write com.google.Chrome DisablePrintPreview -bool true
sudo defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
sudo defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
sudo defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

# ------------------------------------------------------------
# App Store
# ------------------------------------------------------------
# Enable the WebKit Developer Tools in the Mac App Store
sudo defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
sudo defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
sudo defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
sudo defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
sudo defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
sudo defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
sudo defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
sudo defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
sudo defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# ------------------------------------------------------------
# Activity Monitor
# ------------------------------------------------------------
# Show the main window when launching Activity Monitor
sudo defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
sudo defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
sudo defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
sudo defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
sudo defaults write com.apple.ActivityMonitor SortDirection -int 0

# ------------------------------------------------------------
# Default apps
# ------------------------------------------------------------

# Chrome as default
brew install defaultbrowser
defaultbrowser chrome

# Cursor
brew install duti
duti -s com.todesktop.230313mzl4w4u92 .c all
duti -s com.todesktop.230313mzl4w4u92 .cpp all
duti -s com.todesktop.230313mzl4w4u92 .cs all
duti -s com.todesktop.230313mzl4w4u92 .css all
duti -s com.todesktop.230313mzl4w4u92 .csv all
duti -s com.todesktop.230313mzl4w4u92 .go all
duti -s com.todesktop.230313mzl4w4u92 .java all
duti -s com.todesktop.230313mzl4w4u92 .js all
duti -s com.todesktop.230313mzl4w4u92 .jsx all
duti -s com.todesktop.230313mzl4w4u92 .ts all
duti -s com.todesktop.230313mzl4w4u92 .tsx all
duti -s com.todesktop.230313mzl4w4u92 .sass all
duti -s com.todesktop.230313mzl4w4u92 .scss all
duti -s com.todesktop.230313mzl4w4u92 .less all
duti -s com.todesktop.230313mzl4w4u92 .vue all
duti -s com.todesktop.230313mzl4w4u92 .cfg all
duti -s com.todesktop.230313mzl4w4u92 .json all
duti -s com.todesktop.230313mzl4w4u92 .jsx all
duti -s com.todesktop.230313mzl4w4u92 .lua all
duti -s com.todesktop.230313mzl4w4u92 .md all
duti -s com.todesktop.230313mzl4w4u92 .php all
duti -s com.todesktop.230313mzl4w4u92 .pl all
duti -s com.todesktop.230313mzl4w4u92 .py all
duti -s com.todesktop.230313mzl4w4u92 .rb all
duti -s com.todesktop.230313mzl4w4u92 .rs all
duti -s com.todesktop.230313mzl4w4u92 .sh all
duti -s com.todesktop.230313mzl4w4u92 .swift all
duti -s com.todesktop.230313mzl4w4u92 .txt all
duti -s com.todesktop.230313mzl4w4u92 .conf all

# ------------------------------------------------------------
# Security
# ------------------------------------------------------------
# Allow TouchID for Sudo
sudo tee /etc/pam.d/sudo << EndOfMessage
auth sufficient pam_tid.so
$(cat /etc/pam.d/sudo)
EndOfMessage

# Disables signing in as Guest from the login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Disables Guest access to file shares over SMB
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable insecure TFTP service
sudo launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
sudo launchctl disable system/com.apple.telnetd

# Disable sharing of local printers with other computers
cupsctl --no-share-printers

# Disable printing from any address including the Internet
cupsctl --no-remote-any

# Disable remote printer administration
cupsctl --no-remote-admin

# Enable application firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
sudo defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on firewall logging
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
sudo defaults write com.apple.security.firewall EnableStealthMode -bool true

# Prevent automatically allowing incoming connections to signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Disable Internet based spell correction
sudo defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Deactivate the Remote Management Service
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Enable FileVault encryption.
sudo fdesetup enable

sudo -u $(whoami) defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityAdvertisingAllowed -bool no
sudo -u $(whoami) defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityReceivingAllowed -bool no

# Disable remote login (incoming SSH and SFTP connections)
echo "Type 'yes' to the following prompt:"
sudo systemsetup -setremotelogin off

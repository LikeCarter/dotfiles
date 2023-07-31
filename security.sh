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

# Disable remote login (incoming SSH and SFTP connections)
echo "Type 'yes' to the following prompt:"
sudo systemsetup -setremotelogin off

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
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on firewall logging
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Prevent automatically allowing incoming connections to signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Disable Internet based spell correction
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Deactivate the Remote Management Service
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Enable FileVault encryption.
sudo fdesetup enable

sudo -u $(whoami) defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityAdvertisingAllowed -bool no
sudo -u $(whoami) defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityReceivingAllowed -bool no


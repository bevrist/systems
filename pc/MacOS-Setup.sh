#!/bin/bash

set -e

#Check for non sudo
if [ $USER == "root" ]; then
  echo "must run script as user..."
  exit 1
fi
sudo -v
sudo echo "starting..."
cd $(dirname "$0")


#if ssh dir does not exist, generate ssh key
if [ ! -d ~/.ssh ]
then
  mkdir -p ~/.ssh
  # Use secretive for keys instead of generating keys

#   # Using apple keychain for SSH keys
#   echo "Generating SSH Key, MUST USE A PASSWORD!"
#   ssh-keygen -f ~/.ssh/${USER}_key
#   chmod 500 ~/.ssh/${USER}_key
#   echo "Adding SSH Key to Keychain..."
#   ssh-add --apple-use-keychain ~/.ssh/${USER}_key
fi

echo "Host *
  ServerAliveInterval 5
  ServerAliveCountMax 1

  #secretive keystore
	IdentityAgent /Users/${USER}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
  IdentityFile ~/./ssh/<NAME_OF_PUB_KEY_HERE>
  ## e.g. for key 'my-key.pub' with cert 'my-key-cert.pub', use 'IdentityFile ~/.ssh/my-key'

  # #apple keychain
  # UseKeychain yes
  # AddKeysToAgent yes
  # IdentityFile ~/.ssh/${USER}_key

Host play.brettevrist.net
  Port 2213
  User bevrist

Host svn.brettevrist.net
  Port 2500
  User bevrist
" > ~/.ssh/config

# ========= Install Applications =========
#if not installed, Install Homebrew
if ! command -v brew &> /dev/null ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update

#Install Apps
brew install --cask google-drive # xquartz  # install apps that require system password first
brew install --cask rectangle keepingyouawake homebrew/cask-fonts/font-fira-code-nerd-font numi maccy secretive
brew install --cask keepassxc firefox chromium visual-studio-code obsidian
brew install --cask iina grandperspective microsoft-remote-desktop db-browser-for-sqlite ios-app-signer
# orion libreoffice blender flutter steam epic-games discord
# bootstrap-studio http-toolkit stoplight-studio figma bruno
# monitorcontrol hiddenbar cider menuwhere utm
# rocket-typist

# brew install --cask wacom-tablet

brew install zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions starship mas
brew install wget grep findutils rsync watch entr git git-lfs difftastic coreutils lsd restic terminal-notifier macchina
brew install netcat p7zip pv tree rename gnu-sed jq yq atuin htop btop gron hyperfine dust taskell
brew install tokei qpdf rclone syncthing grex
brew install podman docker docker-compose docker-buildx docker-credential-helper
# brew install crane dive  grype trivy  #docker helper tools
brew install ctop kubernetes-cli helm kubectx skaffold k3d
# argocd ; brew install --cask openlens  #Kubernetes extras
# lolcat sl nyancat cowsay fastlane foreman lazydocker lazygit  #fun extras

brew install typst ; brew install --cask skim  #better LaTeX alternative

# install mac app store apps
mas install 497799835   # xcode
mas install 1451685025  # wireguard
mas install 1475387142  # tailscale
mas install 1481853033  # strongbox pro

# recording/presenting software
brew install --cask kdenlive scroll-reverser
mas install 1507246666  # presentify

###

# create local bin dir with open permissions
sudo mkdir -pm 775 /usr/local/bin/

# symlink "aliases" (for `watch` command)
ln -sf $(which kubectl) /usr/local/bin/k
ln -sf $(which docker) /usr/local/bin/d
ln -sf $(which podman) /usr/local/bin/p

# install cht.sh
curl -o /usr/local/bin/cht.sh https://cht.sh/:cht.sh
chmod +x /usr/local/bin/cht.sh

# add gnu grep and find first in PATH
ln -s /opt/homebrew/bin/ggrep /usr/local/bin/grep
ln -s /opt/homebrew/bin/gfind /usr/local/bin/find

#create dev folder and scripts
mkdir -p ~/dev
rsync -rvc Macos/dev ~/
chmod -R 700 ~/dev


### Tool Configuration
# customize zsh prompt
cp Macos/zshrc ~/.zshrc

# atuin history
atuin import auto

#.config/
mkdir -p ~/.config
cp -r Macos/config/ ~/.config/

#.vimrc
cp Macos/vimrc ~/.vimrc

#Zsh-Completions: first time setup\
chmod -R go-w '/opt/homebrew/share'

#Run programs for first time setup
git lfs install
git config --global credential.helper store
git config --global fetch.prune true
git config --global pull.ff only
git config --global color.ui true
git config --global diff.colorMoved zebra
git config --global diff.algorithm histogram
git config --global init.defaultBranch main
git config --global merge.conflictstyle diff3
git config --global transfer.fsckobjects = true
git config --global fetch.fsckobjects = true
git config --global receive.fsckObjects = true
git config --global push.autoSetupRemote
git config --global push.default current
git config --global commit.verbose true
git config --global core.pager delta
git config --global branch.sort -committerdate
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"


#Notes
echo "=============== NOTES ==============="
echo "Restore restic backup files
Sort all Apple apps to folders to make room for new Apps
Open 'secretive' and create an ssh key
Sign ssh pub key with ca_cert
copy pub key to .ssh/ and update ssh config(~/.ssh/config)  'IdentityFile' to point to secretive pub key
Log into Google Drive App
  set google drive app to 'Mirror Files'
Setup 'dev/backup/cron-backup.sh' in crontab
macos Preferences:
  Apple id: disable photos sync and other unused services
  Sign into Google Account for Contacts
  General: Set Default Web Browser
  General > Airdrop & Handoff: uncheck 'Airplay Receiver'
  Desktop & Screen Saver > Screen Saver > Hot Corners: Set bottom right to 'Desktop'
  Dock & Menu Bar: check 'Automatically hide and show the dock', uncheck 'Show recent applications in the dock'
  Add 'Full Disk Access' for iTerm, Terminal, and VSCode
  Spotlight: Disable all but Applications and Calculator
  Keyboard > Text: uncheck 'Add period with double-space'
  Battery > options: 'Wake for network access' never, enable 'Opimize video streaming while on battery'
Setup preferences for apps:
  text edit: preferences: check 'Plain Text'
  firefox browser:
    set firefox as default browser
    sign into firefox sync
    set kagi as search engine
    Customize Toolbar (from left to right):
      Tree Style Tab, Back, Forward, Refresh, URL Bar, Downloads, ublock, Extensions, Application Menu
    extensions: ublock origin, tree style tabs, sponsorblock, privacy badger, i still dont care about cookies, consent-o-matic, Strongbox auto fill      ~keepassXC browser~
    customize firefox configs:
      open page: 'about:config':
        toolkit.legacyUserProfileCustomizations.stylesheets = True
    install custom firefox userChrome.css:
      run '$(pwd)/Macos/install-firefox-userChrome.sh'
    edit Tree Style Tab extension CSS:
      open Tree Style Tab Preferences > Advanced: paste contents of Macos/firefox-treeStyleTab.css
	rectangle: Launch on login, Hide menu bar icon
	keepingyouawake:
    General > check 'Activate at Launch'
    Battery > Check 'Deacivate when battery is below' 10%
	Strongbox:
    Application Settings:
      General: Start at Login, Keep in Menu Bar, dont Always show the dock icon
      Appearance: No Markdown Notes, Database manager: dont show at startup, hide after launching database
      Security: Block screenshots, Auto clear clipboard after 60 seconds, Lock after background for 5 minutes
    Database Settings:
      Side bar: Show sections: dont show quick views
      Touch ID: enable touch id unlock, dont automatically prompt, require password after app exit
  numi: Precision = 3, uncheck 'Show in menu bar', check 'Launch numi at login'
  maccy:
    General > 'Launch at login'
    Storage > Dont save 'Files', HistorySize = 25
    Appearance > 'Show recent copy next to menu icon'
  Terminal.app:
    download rose pine https://github.com/rose-pine/terminal.app
    install rose pine.terminal theme
    profiles:
      enable rose pine theme
      text:
        edit colors > opacity=85%, Blur=5%
        change font to 'fira code mono'
        edit cursor > blinking=true
      window > window size > columns=100, rows=50
      shell > When the shell exits = 'Close if the shell exited cleanly'

Setup Affinity Designer: https://affinity.serif.com
  brew install --cask affinity-designer
Get Pureref: https://pureref.com

RESTART MACOS to finalize xquartz configuration
" | tee ~/Desktop/Setup-Notes.txt

# inactive notes:
  # orion browser:
  #   preferences:
  #     set orion as default browser
  #     appearance > Show Tabs: On the side. Toolbar: check 'Show bookmarks bar' & 'use compact size'. Bookmarks bar: 'Text Only'
  #     passwords > password provider: '3rd party provider'
  #     search > search engine: kagi (set up private window key)
  #     websites > auto play: youtube.com
  #     advanced > check 'allow installation ... Firefox Extensions'
  #   get popular extensions: consent-o-matic, SponsorBlock
  #   get firefox extensions: KeepassXC-browser
  #   extension settings:
  #     KeepassXC: sync with desktop app
  # iTerm:
  #   General > Closing: disable 'Confirm Quit'
  #   Appearance > Tabs: 'Show tab bar even when...'
  #   Profiles > Colors: Color Preset: 'Tango Dark', Minimum Contrast->40
  #   Profiles > Text: Cursor->'Vertical Bar' & 'Blinking Cursor', Font->'Fira code' & Font Size->'12', check: 'Use Ligatures'
  #   Profiles > Window: Transparency->25%, enable blur->5%,
  #   Profiles > Window: Settings for New Windows: Columns: '100', Rows: '50'
  #   Profiles > Terminal: Scrollback Lines: '25,000'
  # Menuwhere:
  #   Hide Menus > 'Apple,Menuwhere'
  #   check 'Hide disabled menu items'
  #   Advanced > check 'Launch automatically at login'
  #   Advanced > uncheck 'Show preferences at launch'
  #   Advanced > Run as 'Faceless' application
  # keepassxc:
  #   general > startup: check 'automatically launch keepass at system startup', check 'minimize window after unlocking database'
  #   general > File Management: uncheck all variants of 'Automatically save ...'
  #   set mac preferences app to allow auto type '⌘+⇧+V' (security > accessibility: add keepassxc)
  #   security > 'lock database after inactivity'=600 sec, check 'Hide entry notes by default'
  #   browser integration > enable, firefox. advanced > check 'never ask before accessing credentials'
  #   connect KeepassXC to orion browser extension

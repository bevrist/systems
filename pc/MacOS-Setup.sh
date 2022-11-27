#!/bin/bash

set -e

#Check for non sudo
if [ $USER == "root" ]; then
  echo "must run script as user..."
  exit 1
fi
sudo echo "starting..."


#if ssh dir does not exist, generate ssh key
if [ ! -d ~/.ssh ]
then
  mkdir -p ~/.ssh
  echo "Generating SSH Key, MUST USE A PASSWORD!"
  ssh-keygen -f ~/.ssh/${USER}_key
  chmod 500 ~/.ssh/${USER}_key
  echo "Adding SSH Key to Keychain..."
  ssh-add --apple-use-keychain ~/.ssh/${USER}_key
fi

echo "Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/${USER}_key
  ServerAliveInterval 5
  ServerAliveCountMax 1

Host play.brettevrist.net
  HostName play.brettevrist.net
  Port 2213
  User bevrist" > ~/.ssh/config


# ========= Install Applications =========
#if not installed, Install Homebrew
if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update

#Install Apps
brew install --cask rectangle keepingyouawake homebrew/cask-fonts/font-fira-code-nerd-font numi maccy
brew install --cask xquartz iterm2 keepassxc firefox google-chrome google-drive visual-studio-code obsidian
brew install --cask cider discord iina grandperspective microsoft-remote-desktop db-browser-for-sqlite
#brew install --cask rancher lens openlens
#brew install --cask blender flutter steam epic-games ios-app-signer alt-tab vlc
#brew install --cask bootstrap-studio chromium http-toolkit postman stoplight-studio drone figma
# monitorcontrol hiddenbar

brew install zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
brew install starship wget grep findutils rsync watch git git-lfs coreutils lsd restic terminal-notifier archey4 python@3.11
brew install netcat p7zip pv htop tree rename gnu-sed jq macchina watchexec dstask hyperfine
brew install docker docker-compose docker-buildx docker-credential-helper ctop kubernetes-cli yq helm kubectx skaffold     #linkerd argocd
# brew install lolcat sl nyancat cowsay rclone fastlane foreman lazydocker lazygit tokei


# symlink aliases
ln -sf /usr/local/bin/kubectl /usr/local/bin/k

# install cht.sh
sudo curl -o /usr/local/bin/cht.sh https://cht.sh/:cht.sh
sudo chmod +x /usr/local/bin/cht.sh


#create dev folder and scripts
mkdir -p ~/dev
rsync -rv Macos/dev ~/
chmod -R 700 ~/dev


# ========== Zsh Configuration ==========
# brew install zsh
echo "Changing shell to zsh..."
/usr/bin/chsh -s /bin/zsh

# customize zsh prompt
cp Macos/zshrc ~/.zshrc


# ========== Tool Configuration ==========
#.config/starship.toml
mkdir ~/.config
cp Macos/starship.toml ~/.config/starship.toml

#.vimrc
cp Macos/vimrc ~/.vimrc

#Zsh-Completions: first time setup
chmod -R go-w '/usr/local/share/zsh'

#TextEdit: use plain text mode as default
defaults write com.apple.TextEdit RichText -int 0

#Run programs for first time setup
git lfs install
git config --global credential.helper store
git config --global pull.ff only
git config --global color.ui true
git config --global init.defaultBranch main
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"


#Notes
echo "=============== NOTES ==============="
echo "Restore restic backup files
Sort all Apple apps to folders to make room for new Apps
Sign ~/.ssh/${USER}_key key with ca_cert
Log into Google Drive App
Setup 'dev/backup/cron-backup.sh' in crontab
Launch apps to initialize: xquartz, rectangle
Google Chrome: Ublock: Setup custom filters https://github.com/quenhus/uBlock-Origin-dev-filter
Manually test backup script then add to crontab (instructions at top): 'dev/backup/cron-backup.sh'
macos Preferences:
  Sign into Google Account for Contacts
  Desktop & Screen Saver > Screen Saver > Hot Corners: Set botom right to 'Desktop'
  Add 'Full Disk Access' for iTerm, Terminal, and VSCode
  Mission Control > uncheck 'When switching to an Application, switch to a Space with open windows for that application'
  Spotlight: Disable all but Applications and Calculator
Setup preferences for apps:
	rectangle: start on login, hide menu bar icon
	keepingyouawake: set enabled by default
	keepassxc:
    set mac prefrences to allow auto type '⌘+⇧+V'
    general > File Management: 'Automatically save after every change' = off
    security: 'Hide entry notes by default' = on
  numi: Precision = 3, 'Show in menu bar' = off, 'Launch numi at login' = on
  maccy:
    General > 'Launch at login'
    Storage > Dont save 'Files' & 'Images', HistorySize = 25
    Appearance > 'Show recent copy next to menu icon'
	iTerm:
    General > Closing: disable 'Confirm Quit'
    Appearence > Tabs: 'Show tab bar even when...'
    Profiles > Colors: Color Preset: 'Tango Dark'
    Profiles > Text: Cursor->'Vertical Bar' & 'Blinking Cursor', Font->'Fira code' & Font Size->'12', check: 'Use Ligatures'
    Profiles > Window: Transparency->25%, enable blur->5,
    Profiles > Window: Settings for New Windows: Colums: '100', Rows: '50'
    Profiles > Terminal: Scrollback Lines: '20,000',
  Rancher Desktop:
    Configure PATH: 'Manual'

Get store apps: XCode, Wireguard
Get Orion Browser: https://browser.kagi.com/
Setup Affinity Designer: https://affinity.serif.com
  brew install --cask affinity-designer
Get Pureref: https://pureref.com

RESTART MACOS to finalize xquartz configuration
" | tee ~/Desktop/Setup-Notes.txt

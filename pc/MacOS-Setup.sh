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
#   # Using apple keychain for SSH keys
#   echo "Generating SSH Key, MUST USE A PASSWORD!"
#   ssh-keygen -f ~/.ssh/${USER}_key
#   chmod 500 ~/.ssh/${USER}_key
#   echo "Adding SSH Key to Keychain..."
#   ssh-add --apple-use-keychain ~/.ssh/${USER}_key
fi

echo "Host *
  #secretive keystore
	IdentityAgent /Users/${USER}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
  ServerAliveInterval 5
  ServerAliveCountMax 1
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

# Host 192.168.1.10
#   ForwardAgent yes
" > ~/.ssh/config

# ========= Install Applications =========
#if not installed, Install Homebrew
if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update

#Install Apps
brew install --cask xquartz google-drive  # install apps that require system password first
brew install --cask rectangle keepingyouawake homebrew/cask-fonts/font-fira-code-nerd-font numi maccy secretive menuwhere
brew install --cask iterm2 keepassxc orion firefox google-chrome visual-studio-code obsidian
brew install --cask discord iina grandperspective microsoft-remote-desktop db-browser-for-sqlite utm
brew install --cask openlens ios-app-signer
# blender flutter steam epic-games alt-tab
# bootstrap-studio chromium http-toolkit postman stoplight-studio drone figma
# monitorcontrol hiddenbar cider
# rocket-typist

brew install zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions starship
brew install wget grep findutils rsync watch entr git git-lfs coreutils lsd restic terminal-notifier macchina python@3.11
brew install qpdf netcat p7zip pv htop tree rename gnu-sed jq rclone atuin clamav
brew install traggo dstask watchexec hyperfine tokei
brew install ctop kubernetes-cli yq helm kubectx skaffold
# linkerd argocd  #Kubernetes extras
docker docker-compose docker-buildx docker-credential-helper ; brew install --cask rancher  #rancher-based Docker OCI
# brew install podman podman-compose ; brew install --cask podman-desktop  #podman OCI
# lolcat sl nyancat cowsay fastlane foreman lazydocker lazygit  #fun extras

# brew install --cask unity-hub; brew install dotnet mono svn  #unity game dev
# brew install pandoc basictex  #LaTeX
# brew install typst ; brew install --cask skim  #better LaTeX alternative


# symlink aliases (for `watch` command)
ln -sf /usr/local/bin/kubectl /usr/local/bin/k

# install cht.sh
sudo curl -o /usr/local/bin/cht.sh https://cht.sh/:cht.sh
sudo chmod +x /usr/local/bin/cht.sh


#create dev folder and scripts
mkdir -p ~/dev
rsync -rvc Macos/dev ~/
chmod -R 700 ~/dev


# ========== Tool Configuration ==========
# customize zsh prompt
cp Macos/zshrc ~/.zshrc

# atuin history
atuin import auto

#.config/
mkdir ~/.config
cp -r Macos/config/ ~/.config/

#.vimrc
cp Macos/vimrc ~/.vimrc

#Zsh-Completions: first time setup
chmod -R go-w '/usr/local/share/zsh'
chmod -R go-w '/usr/local/share'

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
Open 'secretive' and create an ssh key
Sign ~/.ssh/${USER}_key key with ca_cert
Log into Google Drive App
Setup 'dev/backup/cron-backup.sh' in crontab
macos Preferences:
  Apple id: disable photos sync and other unused services
  Sign into Google Account for Contacts
  General: Default browser 'orion'
  Desktop & Screen Saver > Screen Saver > Hot Corners: Set bottom right to 'Desktop'
  Dock & Menu Bar: check 'Automatically hide and show the dock', uncheck 'Show recent applications in the dock'
  Add 'Full Disk Access' for iTerm, Terminal, and VSCode
  Mission Control: uncheck 'When switching to an Application, switch to a Space with open windows for that application'
  Spotlight: Disable all but Applications and Calculator
  Keyboard > Text: uncheck 'Add period with double-space'
  Battery > Power Adapter: uncheck 'Wake for network access'
Setup preferences for apps:
  text edit: preferences: check 'Plain Text'
  orion browser:
    get extensions: firefox: KeepassXC, SponsorBlock
    preferences:
      appearance > Show Tabs: On the side. Toolbar: check 'Show bookmarks bar' & 'use compact size'. Bookmarks bar: 'Text Only'
      passwords > password provider: 'orion', password autofill: uncheck 'offer to autofill...' and uncheck 'offer to save...'
      search > search engine: kagi (set up private window key)
      websites > auto play: youtube
    extension settings:
      KeepassXC: sync with desktop app
	rectangle: start on login, hide menu bar icon
	keepingyouawake: set enabled by default
	keepassxc:
    general > File Management: uncheck all variants of 'Automatically save ...'
    general > startup: check 'automatically launch keepass at system startup', check 'minimize window after unlocking database'
    set mac preferences to allow auto type '⌘+⇧+V' (security > accessibility: add keepassxc)
    security > check 'Hide entry notes by default', 'lock database after inactivity'=600 sec
    browser integration > enable, firefox. advanced > check 'never ask before accessing credentials'
    connect KeepassXC to orion browser extension
  numi: Precision = 3, uncheck 'Show in menu bar', check 'Launch numi at login'
  maccy:
    General > 'Launch at login'
    Storage > Dont save 'Files' & 'Images', HistorySize = 25
    Appearance > 'Show recent copy next to menu icon'
	iTerm:
    General > Closing: disable 'Confirm Quit'
    Appearance > Tabs: 'Show tab bar even when...'
    Profiles > Colors: Color Preset: 'Tango Dark', Minimum Contrast->40
    Profiles > Text: Cursor->'Vertical Bar' & 'Blinking Cursor', Font->'Fira code' & Font Size->'12', check: 'Use Ligatures'
    Profiles > Window: Transparency->25%, enable blur->5%,
    Profiles > Window: Settings for New Windows: Columns: '100', Rows: '50'
    Profiles > Terminal: Scrollback Lines: '25,000',
  Menuwhere:
    Hide Menus > 'Apple,Menuwhere'
    check 'Hide disabled menu items'
    Advanced > check 'Launch automatically at login'
    Advanced > uncheck 'Show preferences at launch'
    Advanced > Run as 'Faceless' application
  Rancher Desktop:
    Configure PATH: 'Manual'

Get store apps: XCode, Wireguard, SnailSVN
Setup Affinity Designer: https://affinity.serif.com
  brew install --cask affinity-designer
Get Pureref: https://pureref.com

RESTART MACOS to finalize xquartz configuration
" | tee ~/Desktop/Setup-Notes.txt

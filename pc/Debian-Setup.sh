#!/bin/bash
# install debian with NO "KDE Desktop" only "SSH" and "System Utilities"
# > Install "KDE desktop" after nvidia drivers with "sudo tasksel"

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
  User bevrist
" > ~/.ssh/config

# set up sshd
curl https://brettevrist.net/share/ca_key.pub | sudo tee /etc/ssh/ca_key.pub
if ! grep -qF "TrustedUserCAKeys" /etc/ssh/sshd_config; then
  echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" | sudo tee -a /etc/ssh/sshd_config
fi
# sudo sed -i 's/#Port\ 22/Port\ 2205/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo systemctl restart ssh


# ========= Install Applications =========
#if not installed, Install Homebrew
if ! command -v brew &> /dev/null ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew update


# install required apps and drivers
DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get full-upgrade -y

# install linux headers for nvidia graphics
sudo apt install linux-headers-amd64 -y

# Add "testing main contrib non-free" to apt sources:
sudo sed -Ei 's/bullseye(.* main)$/testing\1 contrib non-free/g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get full-upgrade -y
sudo apt-get upgrade -y

# install tools and programs
sudo apt-get install -y vim tmux curl wget git git-lfs gpg rsync
sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting
sudo apt-get install -y docker.io docker-compose p7zip-full htop tree rename hyperfine lolcat rclone

brew install starship zsh-completions lsd yq jq macchina
brew install watchexec
brew install ctop kubernetes-cli helm kubectx skaffold k3d  #linkerd argocd

# install cht.sh
sudo curl -o /usr/local/bin/cht.sh https://cht.sh/:cht.sh
sudo chmod +x /usr/local/bin/cht.sh

# symlink aliases
sudo ln -sf /home/linuxbrew/.linuxbrew/bin/kubectl /usr/local/bin/k


#create dev folder and scripts
mkdir -p ~/dev
rsync -rv Debian/dev ~/
chmod -R 700 ~/dev


# ========== Zsh Configuration ===========
# brew install zsh
echo "Changing shell to zsh..."
chsh -s /bin/zsh

# customize zsh prompt
cp Debian/zshrc ~/.zshrc

# ========== Tool Configuration ==========
#".config" folder
rsync -rv Debian/config/* ~/.config

#.vimrc
cp Debian/vimrc ~/.vimrc

#Zsh-Completions: first time setup
chmod -R go-w '/usr/local/share/zsh'

#set up programs for first time
sudo usermod -aG docker $USER
git lfs install
git config --global credential.helper store
git config --global pull.ff only
git config --global color.ui true
git config --global init.defaultBranch main
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"


#Notes
echo "=============== NOTES ==============="
echo 'Run "~/update.sh"

Edit grub boot settings "sudo vim /etc/default/grub":
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_DISABLE_OS_PROBER=false
GRUB_TIMEOUT=2

sudo update-grub

RESTART LINUX
' | tee ~/Setup-Notes.txt

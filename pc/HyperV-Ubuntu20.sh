#!/bin/bash
### HyperV VM with xrdp

#Check for non sudo
if [ $USER == "root" ]
then
    echo "must run script as user..."
    exit
fi
sudo echo "starting..."
cd ~/

# setup xsessionrc
echo "export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" > ~/.xsessionrc

#generate ssh key
mkdir -p ~/.ssh
echo "Generating SSH Key (use no password)..."
ssh-keygen -f ~/.ssh/${USER}_key

##### update #####
sudo apt update
sudo apt upgrade -y
sudo apt autoremove --purge -y
sudo apt clean -y

##### INSTALL APPS #####
mkdir -p ~/dev/

#install apt packages
sudo apt update
sudo apt install vim xrdp ssh git git-lfs htop zsh x11-apps fonts-firacode gnome-tweaks -y # system
sudo apt install neofetch tldr p7zip-full docker.io docker-compose ranger -y #other

#install vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f ./packages.microsoft.gpg
sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y

#install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm ./google-chrome-stable_current_amd64.deb

##### END INSTALL APPS #####


##### CREATE SHELL HELPER SCRIPTS #####
mkdir -p ~/dev/
### update.sh ###
echo "apt update && apt upgrade -y && apt autoremove -y && apt clean -y && tldr --update
" > ~/dev/update.sh
chmod 500 ~/dev/update.sh

#getip.sh get local ip
echo 'case "$1" in
	"-4")
		API="http://v4.ipv6-test.com/api/myip.php"
		;;
	"-6")
		API="http://v6.ipv6-test.com/api/myip.php"
		;;
	*)
		API="http://ipv6-test.com/api/myip.php"
		;;
esac
curl -s "$API"
echo # Newline.
' > ~/dev/getip.sh
chmod 700 ~/dev/getip.sh

##### END CREATE SHELL HELPER SCRIPTS #####


### configure apps ###
#sshd config
sudo wget -O /etc/ssh/ca_key.pub https://brettevrist.net/share/ca_key.pub
sudo sed -i '/PubkeyAuthentication/a TrustedUserCAKeys \/etc\/ssh\/ca_key.pub' /etc/ssh/sshd_config
sudo sed -i '/PasswordAuthentication/c PasswordAuthentication no' /etc/ssh/sshd_config
sudo systemctl restart ssh

#.vimrc
echo "set number
syntax on
set ignorecase
set incsearch
set scrolloff=3
set sidescrolloff=5
" > ~/.vimrc

#zsh
echo "Changing shell to zsh..."
/usr/bin/chsh -s /bin/zsh
# grml-zsh-config   "a lightweight but useful zsh config"
wget -O ~/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# .zshrc  configure prompt and add ssh keys to ssh-agent
echo '
grml_theme_add_token right-arrow "> "

zstyle ":prompt:grml:left:setup" items rc change-root user at host path vcs right-arrow

#only show neofetch on first terminal
if [ "$(tty)" = "/dev/pts/0" ]; then
  neofetch
fi

export PATH=$PATH:/snap/bin

alias open="xdg-open"
alias getip="~/dev/getip.sh"
' >> ~/.zshrc

##### configure programs #####
git lfs install
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"
# tldr config
tldr --update
# neofetch config
neofetch
# docker
sudo usermod -aG docker $USER
# gnome desktop
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
gsettings set org.gnome.shell.extensions.desktop-icons show-home false

#disable terminal MOTD
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo chmod -x /etc/update-motd.d/80-livepatch

### clean up ###
sudo apt update
sudo apt upgrade -y
sudo apt autoremove --purge -y
sudo apt clean -y


echo "
########## SETUP COMPLETE! ##########
"

##### Notes #####
echo "=============== NOTES ==============="
echo "
Sign into Google Chrome
Setup VSCode
Setup windows folder share and connect to it within ubuntu:
	https://www.tectut.com/2015/02/hyper-v-file-sharing-between-and-host-and-guest/

Enable nested virtualization in for this VM
OSX VM: https://github.com/sickcodes/Docker-OSX

RESTART!
" | tee ~/Desktop/Setup-Notes.txt

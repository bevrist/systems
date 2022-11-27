#!/bin/bash
### Bretts Fresh Ubuntu Machine Install script

#Check for non sudo
if [ $USER == "root" ]
then
    echo "must run script as user..."
    exit
fi
sudo echo "starting..."
cd ~/


#generate ssh key
mkdir -p ~/.ssh
echo "Generating SSH Key (use no password for auto-adding certificates)..."
ssh-keygen -f ~/.ssh/${USER}_key
eval $(ssh-agent)
echo "Adding SSH Key to ssh-agent..."
ssh-add ~/.ssh/${USER}_key

##### update #####
sudo apt update
sudo apt upgrade -y
sudo apt autoremove --purge -y
sudo apt clean -y


##### INSTALL APPS #####
mkdir -p ~/dev/
touch ~/dev/startup.sh

#install apt packages
sudo apt update
sudo apt install vim ssh git git-lfs htop zsh x11-apps -y # system
# sudo apt install gnome-system-monitor file-roller gnome-font-viewer gthumb caffeine -y #system-gui
sudo apt install flameshot seahorse keepassxc fonts-firacode -y #gui #TO DO check seahorse budgie 20
sudo apt install neofetch tldr p7zip-full vlc docker.io docker-compose ranger pv -y #other
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager libguestfs-tools -y #KVM https://help.ubuntu.com/community/KVM/Installation #TO DO kvm ubuntu 20
# sudo adduser ${USER} kvm  #TO DO FIXME verify if needed
# sudo apt install sl lolcat nyancat  vlc
# sudo apt install blender steam qdirstat

#install ppa apt packages
# sudo add-apt-repository ppa:alessandro-strada/ppa -y # google-drive-ocamlfuse #TO DO replace with insync
# sudo add-apt-repository ppa:openrazer/stable -y # openrazer
# sudo add-apt-repository ppa:polychromatic/stable -y # polychromatic

sudo apt update
# sudo apt install google-drive-ocamlfuse -y #TO DO replace with insync
# sudo apt install openrazer-meta polychromatic -y

#install snap packages
sudo snap install code --classic
sudo snap install slack --classic
# sudo snap install blender --classic
sudo snap install authy --beta


#install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm ./google-chrome-stable_current_amd64.deb

#install discord
wget https://dl.discordapp.net/apps/linux/0.0.10/discord-0.0.10.deb
sudo apt install ./discord-0.0.10.deb -y
rm ./discord-0.0.10.deb

# #install Unity Hub #TO DO verify if valid on budgie 20
# sudo mkdir -p /opt/unity-hub/
# sudo chown ${USER}:${USER} /opt/unity-hub
# sudo wget -O /opt/unity-hub/UnityHub.AppImage https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage
# sudo chmod 555 /opt/unity-hub/UnityHub.AppImage
# sudo wget -O /opt/unity-hub/unity-logo.png https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/unity-512.png
# sudo echo "[Desktop Entry]
# Type=Application
# Name=UnityHub
# Comment=Unity Game Engine Launcher
# Icon=/opt/unity-hub/unity-logo.png
# Exec=/opt/unity-hub/UnityHub.AppImage
# Categories=Game;
# " | sudo tee /usr/share/applications/unity-hub.desktop

#TO DO install other apps
	#macos?

# remove unneeded packages
sudo apt remove libreoffice-common chromium-browser gnome-calendar rhythmbox -y #budgie 18.04 packages #TO DO check if valid budgie 20
rm -rf Templates # remove libre office templates folder
sudo apt autoremove --purge -y

##### END INSTALL APPS #####


##### CREATE SHELL HELPER SCRIPTS #####
mkdir -p ~/dev/
### update.sh ###
echo "apt update && apt upgrade -y && apt autoremove -y && apt clean -y && tldr --update
" > ~/dev/update.sh
chmod 500 ~/dev/update.sh

### keepass-update.sh ### #TO DO FIXME
# echo 'NOW=$(date +"%m_%d_%Y")
# ssh -p 2213 bevrist@play.brettevrist.net "mv /var/www/brettevrist.net/share/keePass/*.kdbx /var/www/brettevrist.net/share/keePass/_OLD/"
# scp -P 2213 /mnt/c/Users/B-PC/Google\ Drive/Documents/_KeePass/BrettsPassDatabase.kdbx bevrist@play.brettevrist.net:/var/www/brettevrist.net/share/keePass/BrettsPassDatabase_"$NOW".kdbx
# ' > ~/dev/keepass-update.sh
# chmod 700 ~/dev/keepass-update.sh

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

#b-servers.sh
echo 'ssh -Y -p 2215 bevrist@play.brettevrist.net
' > ~/dev/b-media.sh
chmod 700 ~/dev/b-media.sh

echo 'ssh -Y -p 2213 bevrist@play.brettevrist.net
' > ~/dev/b-web.sh
chmod 700 ~/dev/b-web.sh

echo 'ssh -Y -p 2216 bevrist@play.brettevrist.net
' > ~/dev/b-source.sh
chmod 700 ~/dev/b-source.sh

echo 'ssh -Y -p 2210 bevrist@play.brettevrist.net
' > ~/dev/b-test-0.sh
chmod 700 ~/dev/b-test-0.sh

echo 'ssh -Y -p 2211 bevrist@play.brettevrist.net
' > ~/dev/b-test-1.sh
chmod 700 ~/dev/b-test-1.sh

echo 'ssh -Y -p 2220 bevrist@play.brettevrist.net
' > ~/dev/b-test-2.sh
chmod 700 ~/dev/b-test-2.sh

echo 'ssh -Y -p 2230 bevrist@play.brettevrist.net
' > ~/dev/b-test-3.sh
chmod 700 ~/dev/b-test-3.sh

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
echo "
grml_theme_add_token right-arrow '> '

zstyle ':prompt:grml:left:setup' items rc change-root path vcs right-arrow

# add ssh keys and certificates
if ssh-add -l | grep -q "${USER}_key (RSA-CERT)"; then
	: #do nothing if cert already exists
else
	ssh-add ~/.ssh/${USER}_key 2>/dev/null
fi

#only show neofetch on first terminal
# if [ \"$(tty)\" = \"/dev/pts/0\" ]; then
  neofetch
# fi

export PATH=\$PATH:/snap/bin

alias getip='~/dev/getip.sh'
alias open='xdg-open'
" >> ~/.zshrc

##### configure programs #####
git lfs install
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"
# tldr config
tldr --update
# neofetch config
neofetch
sudo sed -i '/ascii_distro=/c ascii_distro="Ubuntu-Budgie"' ~/.config/neofetch/config.conf
sudo sed -i '/# info "Disk" disk/c info "Disk" disk' ~/.config/neofetch/config.conf
# # google-drive-ocamlfuse config #TO DO replace with insync
# mkdir -p ~/GoogleDrive
# echo "nohup google-drive-ocamlfuse -f /home/${USER}/GoogleDrive &
# rm nohup.out" >> ~/dev/startup.sh #TO DO verify startup still works the same in budgie 20
# docker
sudo usermod -aG docker bevrist

#add sam account
echo "========== creating user: sam =========="
sudo useradd -m -s /bin/zsh sam
sudo passwd -d sam
sudo sed -i '/Authentication:/a AllowUsers bevrist' /etc/ssh/sshd_config
chmod 700 /home/bevrist

#disable terminal MOTD
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo chmod -x /etc/update-motd.d/80-livepatch

#enable startup.sh execution
chmod 500 ~/dev/startup.sh

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
Sign ~/.ssh/${USER}_key key with ca_cert
Add ~/dev/startup.sh to Ubuntu startup applications
Sign into Google Chrome
setup VSCode settings sync
bind flameshot to print screen button
run: 'sudo snap remove ubuntu-budgie-welcome'

### THEMES ### #TO DO update for budgie 20
Budgie Themes: Plata desktop theme
Budgie Desktop Settings:
	Widgets: Plata-Noir-Compact
	Icons: Papirus-Dark
	Cursor: DMZ-Black
Budgie Applets:
	Calendar Applet
	Global Menu Applet
	weather applet (Displays the weather on your panel)

hide breeze_* cursors #TO DO update for budgie 20
change top panel
	Global Menu (with bold application name)
	Pixel-Saver
	expose (with window previews disabled)
	-
	calendar applet
	set hot corners (with expose desktop)
	weather
	-
	other stuff

plank preferences
keyboard settings: replace search (alt+F2) with alt+space #TO DO update for budgie 20

RESTART!
" > ~/Desktop/Setup-Notes.txt
cat ~/Desktop/Setup-Notes.txt



# Insure grub is installed to the correct linux drive #TO DO FIXME EFI
# sudo apt install --reinstall grub-efi
# sudo fdisk -l
# `sudo grub-install --recheck /dev/sda` # sub /dev/sda for boot drive
# sudo update-grub /dev/sda

#TO DO try
sudo apt update && sudo apt install evince -y # evince previewer (like macos preview)
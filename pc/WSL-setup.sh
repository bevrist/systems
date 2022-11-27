#!/bin/bash

### Bretts WSL Ubuntu new install config script

USER_HOME=$(eval echo ~${SUDO_USER})    # get user home directory

#Check for sudo
if [ $USER != "root" ]
then
    echo "must run script as sudo..."
    exit
fi

### generate ssh key ###
sudo -u ${SUDO_USER} mkdir -p ${USER_HOME}/.ssh
echo "Generating SSH Key..."
sudo -u ${SUDO_USER} ssh-keygen -f ${USER_HOME}/.ssh/${SUDO_USER}_key

### update ###
apt update
apt dist-upgrade -y

### install apps ###
apt install -y vim keychain tldr tmux p7zip-full git git-lfs zsh


##### CREATE SHELL HELPER SCRIPTS #####
mkdir -p ${USER_HOME}/dev/
### update.sh ###
sudo -u ${SUDO_USER} echo "apt update && apt upgrade -y && apt autoremove -y && apt clean -y && tldr --update
" > ${USER_HOME}/dev/update.sh
chmod 500 ${USER_HOME}/dev/update.sh

### keepass-update.sh ###
sudo -u ${SUDO_USER} echo 'NOW=$(date +"%m_%d_%Y")
ssh -p 2213 bevrist@play.brettevrist.net "mv /var/www/brettevrist.net/share/keePass/*.kdbx /var/www/brettevrist.net/share/keePass/_OLD/"
scp -P 2213 /mnt/c/Users/B-PC/Google\ Drive/Documents/_KeePass/BrettsPassDatabase.kdbx bevrist@play.brettevrist.net:/var/www/brettevrist.net/share/keePass/BrettsPassDatabase_"$NOW".kdbx
' > ${USER_HOME}/dev/keepass-update.sh
chmod 700 ${USER_HOME}/dev/keepass-update.sh

### rsync-backup.sh ###
sudo -u ${SUDO_USER} echo 'echo "Syncing /mnt/e/Game Dev/..."
rsync -e "ssh -p 2215" -ru --delete --info=progress2 /mnt/e/Game\ Dev bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/
echo "Syncing /mnt/e/Games Archive/..."
rsync -e "ssh -p 2215" -ru --delete --info=progress2 /mnt/e/Games\ Archive bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/
echo "Syncing /mnt/e/Learn/..."
rsync -e "ssh -p 2215" -ru --delete --info=progress2 /mnt/e/Learn bevrist@play.brettevrist.net:/mnt/6TB-5400RPM/BACKUP/
' > ${USER_HOME}/dev/rsync-backup.sh
chmod 700 ${USER_HOME}/dev/rsync-backup.sh

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
' > ${USER_HOME}/dev/getip.sh
chmod 700 ${USER_HOME}/dev/getip.sh

#b-servers.sh
sudo -u ${SUDO_USER} echo 'ssh -Y -p 2215 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-media.sh
chmod 700 ${USER_HOME}/dev/b-media.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2213 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-web.sh
chmod 700 ${USER_HOME}/dev/b-web.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2216 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-source.sh
chmod 700 ${USER_HOME}/dev/b-source.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2210 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-test-0.sh
chmod 700 ${USER_HOME}/dev/b-test-0.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2211 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-test-1.sh
chmod 700 ${USER_HOME}/dev/b-test-1.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2220 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-test-2.sh
chmod 700 ${USER_HOME}/dev/b-test-2.sh

sudo -u ${SUDO_USER} echo 'ssh -Y -p 2230 bevrist@play.brettevrist.net
' > ${USER_HOME}/dev/b-test-3.sh
chmod 700 ${USER_HOME}/dev/b-test-3.sh

##### END CREATE SHELL HELPER SCRIPTS #####

### config apps ###
#Bash
# xserver, need to install "Xming" on host machine for GUI apps
sudo -u ${SUDO_USER} echo "export DISPLAY=localhost:0.0" >> ${USER_HOME}/.bash_profile
# ssh_key
sudo -u ${SUDO_USER} echo "eval \$(keychain -q --eval ~/.ssh/${SUDO_USER}_key)" >> ${USER_HOME}/.bash_profile

#.inputrc
sudo -u ${SUDO_USER} echo "set completion-ignore-case On" > ${USER_HOME}/.inputrc

#.vimrc
sudo -u ${SUDO_USER} echo "set number" > ${USER_HOME}/.vimrc		#:set nu
sudo -u ${SUDO_USER} echo "syntax on" >> ${USER_HOME}/.vimrc		#:set filetype || :set filetype=html
sudo -u ${SUDO_USER} echo "set ignorecase" >> ${USER_HOME}/.vimrc	#:set ic

#zsh
echo "Changing shell to zsh, enter user password:"
sudo -u ${SUDO_USER} /usr/bin/chsh -s /bin/zsh
# grml-zsh-config   "a lightweight but useful zsh config"
sudo -u ${SUDO_USER} wget -O ${USER_HOME}/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# .zshrc  configure prompt and add ssh keys to keychain
sudo -u ${SUDO_USER} echo "
grml_theme_add_token right-arrow '> '

zstyle ':prompt:grml:left:setup' items rc change-root virtual-env path vcs right-arrow

export DISPLAY=localhost:0.0

eval \$(keychain -q --eval ~/.ssh/${SUDO_USER}_key)" >> ${USER_HOME}/.zshrc

### run programs for first time setup ###
sudo -u ${SUDO_USER} git lfs install
sudo -u ${SUDO_USER} tldr --update
sudo -u ${SUDO_USER} git config --global user.name "Brett Evrist"
sudo -u ${SUDO_USER} git config --global user.email "brettevrist10@gmail.com"

### clean up ###
apt autoremove -y
apt clean -y


#Notes
echo "Need to install xming to use GUI apps"
echo "Remember to sign ~/.ssh/${USER}_key key with ca_cert"
echo 'Run "zsh" now'

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


#generate ssh key
mkdir -p ~/.ssh
echo "Generating SSH Key (use no password)..."
ssh-keygen -f ~/.ssh/${USER}_key
chmod 500 ~/.ssh/${USER}_key

echo "Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/${USER}_key
  ServerAliveInterval 5
  ServerAliveCountMax 1
" > ~/.ssh/config


##### INSTALL APPS #####
#install apt packages
sudo apt update
sudo apt install -y vim xrdp ssh git git-lfs htop zsh zsh-autosuggestions zsh-syntax-highlighting wget tree x11-apps fonts-firacode gnome-tweaks neofetch htop tree jq tldr p7zip-full docker.io docker-compose ranger rsync netcat rename

sudo apt install -y keepassxc vlc

#install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

#install vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
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

### update.sh ###
echo 'apt update && apt upgrade -y && apt autoremove -y && apt clean -y && sudo -u $SUDO_USER tldr --update
' > ~/dev/update.sh
chmod 500 ~/dev/update.sh
##### END CREATE SHELL HELPER SCRIPTS #####

# ========== Zsh Configuration ==========
echo "Changing shell to zsh..."
/usr/bin/chsh -s /bin/zsh

# customize zsh prompt
echo '
neofetch

export PATH=$PATH:/snap/bin

### Aliases
alias open="xdg-open"
alias ls="ls -G"
alias la="ls -lahG"
alias ll="ls -lhG"
alias k="kubectl"
alias d="docker"
alias getip="~/dev/getip.sh"

### zsh prompt customizations
# auto cd
setopt autocd
# case insensitive tab completion
# zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*" matcher-list "" "+m:{a-zA-Z}={A-Za-z}" "+r:|[._-]=* r:|=*" "+l:|=* r:|=*"
autoload -U compinit && compinit
# up arrow down arrow history load
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# option+arrow shell navigation
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

### zsh prompt extensions
# zsh case insensitive tab completion
# zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
# zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*" matcher-list "" "+m:{a-zA-Z}={A-Za-z}" "+r:|[._-]=* r:|=*" "+l:|=* r:|=*"
autoload -U compinit  && compinit
# zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# zsh-autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

' >> ~/.zshrc

# ========== Tool Configuration ==========
#.config/starship.toml
mkdir -p ~/.config
echo '# https://starship.rs/config

add_newline = false
command_timeout = 1000

[character]
success_symbol = "[>](bold white)"
error_symbol = "[>](bold red)"

[line_break]
disabled = true

[status]
disabled = false
format = "[$status]($style)"

[cmd_duration]
format = "[took $duration]($style) "
#show_notifications = true
#min_time_to_notify = 5000

[directory]
truncate_to_repo = false
style = "white"
read_only = " "
format = "[$path]($style)[$read_only]($read_only_style)"

[git_branch]
symbol = " "
format = " [\\([$symbol$branch](green)\\)](purple)"
only_attached = true
[git_commit]
format= "[\\([$hash](green)\\)](purple) "
[git_status]
format = "([\\[$all_status$ahead_behind\\]](purple)) "
stashed = "[$](bold orange)"
renamed = "[»](bold blue)"
deleted = "[✘](bold red)"
staged = "[+](bold green)"
conflicted = "[✖](red)"
modified = "[●](bold blue)"
behind = "[⇣$count](bold white)"
ahead = "[⇡$count](bold white)"
diverged = "[⇕$count](bold white)"
untracked = "[?](bold yellow)"

### Symbol config ###
[aws]
symbol = "  "
[conda]
symbol = " "
[dart]
symbol = " "
[docker_context]
symbol = " "
[elixir]
symbol = " "
[elm]
symbol = " "
[golang]
symbol = " "
[hg_branch]
symbol = " "
[java]
symbol = " "
[julia]
symbol = " "
[memory_usage]
symbol = " "
[nim]
symbol = " "
[nix_shell]
symbol = " "
[package]
symbol = " "
[perl]
symbol = " "
[php]
symbol = " "
[python]
symbol = " "
[ruby]
symbol = " "
[rust]
symbol = " "
[scala]
symbol = " "
[swift]
symbol = "ﯣ "
' > ~/.config/starship.toml

#.vimrc
echo "set number
syntax on
set ignorecase
set incsearch
set scrolloff=3
set sidescrolloff=5
" > ~/.vimrc

#sshd config
sudo wget -O /etc/ssh/ca_key.pub https://brettevrist.net/share/ca_key.pub
sudo sed -i '/PubkeyAuthentication/a TrustedUserCAKeys \/etc\/ssh\/ca_key.pub' /etc/ssh/sshd_config
sudo sed -i '/PasswordAuthentication/c PasswordAuthentication no' /etc/ssh/sshd_config
sudo systemctl restart ssh

#disable terminal MOTD
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo chmod -x /etc/update-motd.d/80-livepatch

##### configure programs #####
git lfs install
git config --global pull.rebase false
git config --global init.defaultBranch main
git config --global user.name "Brett Evrist"
git config --global user.email "brettevrist10@gmail.com"
tldr --update
neofetch
sudo usermod -aG docker $USER

# setup xsessionrc
echo "export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" > ~/.xsessionrc

# clean-up
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

Enable nested virtualization in for this VM
OSX VM: https://github.com/sickcodes/Docker-OSX

RESTART!
" | tee ~/Desktop/Setup-Notes.txt


#Notes
echo "=============== NOTES ==============="
echo "Sign ~/.ssh/${USER}_key key with ca_cert
Sign into Google Chrome
Setup VSCode
Setup preferences for apps:
	keepassxc: change default saving behavior

Enable nested virtualization in for this VM
OSX VM: https://github.com/sickcodes/Docker-OSX

RESTART!
" | tee ~/Desktop/Setup-Notes.txt

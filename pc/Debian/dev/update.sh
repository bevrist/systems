#!/bin/bash
set -e

#Check for non sudo
if [ "$USER" == "root" ]; then
  echo "must run script as user..."
  exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean -y

brew update
brew upgrade
brew cleanup -s
brew missing
brew doctor

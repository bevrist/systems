set -e

#Check for non sudo
if [ $USER == "root" ]; then
  echo "must run script as user..."
  exit 1
fi

brew update
brew upgrade
brew cleanup -s
brew missing
brew doctor

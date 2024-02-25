#!/bin/bash
# REQUIRES WINDOWS 11 FOR MIRRORED NETWORKING

# install wsl distro
  # wsl --install -d debian
# uninstall wsl distro
  # wsl --unregister debian

export WINDOWS_USERNAME='B-PC'
export WSL_MEMORY='28GB'

set -e

# check for non sudo
if [ b-pc == "root" ]; then
  echo "must run script as user..."
  exit 1
fi
sudo -v
sudo echo "starting..."
cd


### Create dev Scripts ###
mkdir -p dev

# create networking scripts
printf "'[wsl2]
networkingMode=mirrored
memory=${WSL_MEMORY}
' > /mnt/c/Users/${WINDOWS_USERNAME}/.wslconfig
" > dev/network-lan.sh && chmod +x dev/network-lan.sh

printf "'[wsl2]
#networkingMode=mirrored
memory=${WSL_MEMORY}
' > /mnt/c/Users/${WINDOWS_USERNAME}/.wslconfig
" > dev/network-local.sh && chmod +x dev/network-local.sh

# create update script
printf 'apt update && apt upgrade -y && apt autoremove -y && apt clean -y
' > dev/update.sh && chmod +x dev/update.sh

### # ###

# enable systemd if not enabled
if ! sudo systemctl status; then
  printf '[boot]
  systemd=true
  ' | sudo tee /etc/wsl.conf > /dev/null
  echo "in powershell, reboot wsl: 'wsl --shutdown'"
  exit 0
fi

# ensure packages are up to date
sudo apt update
sudo apt upgrade -y

# install packages
sudo apt install -y vim tmux wget curl rsync tree gpg binutils git git-lfs p7zip-full rename

# install docker
sudo apt install -y docker-compose
sudo usermod -aG docker $USER

# install nvidia container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor --yes -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# # download ollama models
# sudo docker run -d --gpus=all -v $HOME/.ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
# sudo docker exec -it ollama ollama pull dolphin-mixtral
# sudo docker exec -it ollama ollama pull codellama
# sudo docker container stop ollama
# sudo docker container rm ollama

printf "if docker ps -a -f name=ollama -q > /dev/null; then
  docker start ollama
else
  docker run -d --gpus=all -v $HOME/.ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
fi
echo run a model with: 'docker exec -it ollama ollama run dolphin-mixtral'
echo run ollama ui with: 'docker run -p 3000:3000 -e OLLAMA_HOST='http://$(ip n | grep eth0 | grep -vP '\d+\.\d+\.\d+\.1 ' | awk '{print $1}'):11434' ghcr.io/ivanfioravanti/chatbot-ollama:main npx next start --hostname 0.0.0.0'
" > dev/start-ollama.sh && chmod +x dev/start-ollama.sh

# TODO add stable diffusion image apps

sudo shutdown now

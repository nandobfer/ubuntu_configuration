#!/bin/bash

# saves the script directory to search for other scripts later
SCRIPT=$(readlink -f "$0")
WORK_DIR=$(dirname "$SCRIPT")

FONTS="$HOME/.local/share/fonts"

[ ! -d "$FONTS" ] && mkdir "$FONTS"

echo "Updating packages"
sudo apt update -y
echo

echo "Upgrading packages"
sudo apt full-upgrade -y
echo

PACKAGES="neovim curl git vlc gnome-tweaks cmatrix neofetch"
echo "installing must have packages"
echo $PACKAGES | xargs sudo apt install -y
echo

echo "Downloading and installing tldr++, a nice CLI manual for the most used commands (run `$ tldr tldr` for a usage tutorial)"
wget -O /tmp/tldr.tgz https://github.com/isacikgoz/tldr/releases/download/v1.0.0-alpha/tldr_1.0.0-alpha_linux_amd64.tar.gz
cd /tmp && tar -xzvf tldr.tgz
cd tldr
sudo mv tldr /usr/local/bin
sudo chmod +x /usr/local/bin/tldr
cd $WORK_DIR

echo "installing albert launcher"
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
sudo apt update
sudo apt install albert

echo "Installing Zsh and defining it as default shell"
sudo apt install zsh -y
echo

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo

echo "Installing Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
echo

echo "Creating ~/bin directory"
[ ! -d ~/bin ] && mkdir ~/bin

echo "cloning commands"
CODE="$HOME/code"
[ ! -d "$CODE" ] && mkdir "$CODE"
git clone https://github.com/nandobfer/linux-scripts $CODE/linux-scripts
cp -r $CODE/linux-scripts/* $HOME/bin/
sudo chmod +x $HOME/bin/*

echo "copying fonts"
cp -r $WORK_DIR/fonts/* $FONTS/

echo "copying doffiles"
echo ".config"
cp -r $WORK_DIR/.config $HOME/
echo ".oh_my_zsh"
cp -r $WORK_DIR/.oh_my_zsh $HOME/
echo ".p10k.zsh"
cp $WORK_DIR/.p10k.zsh $HOME/
echo ".zshrc"
cp $WORK_DIR/.zshrc $HOME/

echo "installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

echo "installing node.js"
nvm install node

echo "installing yarn and nodemon"
npm install -g yarn nodemon

echo "installing vscode"
snap install code --classic

echo "installing spotify"
snap install spotify

echo "installing gnome_extensions"
$WORK_DIR/gnome_extensions.sh

chsh -s $(which zsh)



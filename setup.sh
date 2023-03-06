#!/bin/bash

echo "Home sweet home"
echo ""

echo "Installing Zsh..."
echo ""

sudo dnf install zsh -y

echo "Installing OhMyZsh..."
echo ""
echo 'y' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting up Zsh..."
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="half-life"/g' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

echo "Installing zsh-syntax-highlighting..."
echo ""

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing zsh-autosuggestions..."
echo ""

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing neovim dependencies..."
echo ""

sudo dnf -y install ninja-build libtool cmake gcc gcc-c++ make pkgconfig unzip gettext curl

echo "Downloading and installing neovim..."
echo ""

git clone https://github.com/neovim/neovim
cd neovim
git checkout nightly
make CMAKE_BUILD_TYPE=Release
sudo make install

echo "Configuring neovim..."
echo ""
git clone https://github.com/dylanxyz/neovim.git ~/.config/nvim

echo "Done!"
echo ""

zsh

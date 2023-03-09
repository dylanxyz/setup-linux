#!/bin/bash

function log {
    echo ""
    echo $1
}

function init {
    sudo dnf upgrade --refresh -y
    sudo dnf install make cmake gcc g++ -y
}

function setup-terminal {
    log "Installing Zsh..."
    sudo dnf install zsh -y

    log "Installing OhMyZsh..."
    echo 'y' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    log "Setting up Zsh..."
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="half-life"/g' ~/.zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

    log "Installing zsh plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    chsh -s $(which zsh)
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
}


function install-rust {
    log "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install-julia {
    log "Installing julia dependencies..."
    sudo dnf install libatomic1 gfortran perl wget m4 cmake pkg-config curl

    log "Downloading julia..."
    git clone https://github.com/JuliaLang/julia ~/.local/julia
    cd ~/.local/julia
    git checkout $(curl -s https://api.github.com/repos/JuliaLang/julia/tags | grep '"name":*' | cut -d : -f 2,3 | tr -d \", | head -n 1)

    log "Building julia..."
    make

    log "Installing julia at ~/.local/bin/julia"
    ln -s ~/.local/julia/julia ~/.local/bin/julia
}

function install-crystal {
    log "Installing Crystal..."
    curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --channel=nightly
}

init
setup-terminal
install-rust
install-julia
install-crystal

log "Done!"

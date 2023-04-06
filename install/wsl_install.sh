#!/usr/bin/env bash

# Run to bootstrap wsl config on a fresh Debian installation:
#   cd && bash <(curl https://raw.githubusercontent.com/urob/dotfiles/main/install/wsl_install.sh)

# location of dotfiles
DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# make sure git is installed
if ! command -v git &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install git
fi

# clone remote dotfiles repository
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# upgrade Debian to sid
sudo cp "$DOTFILES/install/sources.list" /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install apt-listbugs
sudo apt-get -y upgrade       # do minimal upgrade first
sudo apt-get -y dist-upgrade  # then do full upgrade
sudo apt-get -y autoremove

# install Debian packages (packages.lst must have unix file endings)
sudo apt-get -y install $(cat $DOTFILES/install/packages.lst)
sudo apt-get clean

# install latest neovim
source $DOTFILES/install/nvim_install.sh

# clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " key
    [[ $key =~ ^[Yy]$ ]] && rm -rf ${f}
done

# install dotfiles
source $DOTFILES/install/dot_install.sh

# make zsh the default shell
chsh -s $(which zsh)

# Activate systemd and fix interop bug  https://github.com/microsoft/WSL/issues/8843
sudo cp "$DOTFILES/install/wsl.conf" /etc/wsl.conf
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'


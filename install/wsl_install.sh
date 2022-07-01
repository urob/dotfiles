#!/usr/bin/env bash

## Run the following to bootstrap environment in a fresh Debian installation:
# curl -fLo ~/wsl_install.sh https://raw.githubusercontent.com/urob/dotfiles/main/install/wsl_install.sh
# chmod +x ~/wsl_install.sh && ~/wsl_install.sh

# location of dotfiles
DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# make sure git is installed
if ! command -v git &> /dev/null; then
    sudo apt-get update
    sudo apt-get install git
fi

# clone remote dotfiles repository
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# upgrade Debian to bookworm
sudo cp ${DOTFILES}/install/sources.list /etc/apt/sources.list
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt autoremove

# install Debian packages (packages.lst must have unix file endings)
sudo apt-get install $(cat $DOTFILES/install/packages.lst)

# clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " key
    [[ $key =~ ^[Yy]$ ]] && rm -rf ${f}
done

# install dotfiles
source $DOTFILES/install/install.sh

# make zsh the default shell
chsh -s $(which zsh)

# install miniconda
# curl -fLo ~/conda_install.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash ~/conda_install.sh

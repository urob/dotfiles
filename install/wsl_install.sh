#!/usr/bin/env bash

# local and remote location of dotfiles
DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# get git
sudo apt-get update
sudo apt-get install git

# clone remote dotfiles dir
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# upgrade to bookworm
sudo cp ${DOTFILES}/install/sources.list /etc/apt/sources.list
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt autoremove

# install packages from packages.lst (must have unix file endings)
sudo apt-get install $(cat $DOTFILES/install/packages.lst)

# clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " YN
    [[ ${YN} =~ ^[Yy]$ ]] && rm -rf ${f}
done

# link dotfiles to home directory
source $DOTFILES/install/install.sh

# make zsh the default shell
chsh -s $(which zsh)


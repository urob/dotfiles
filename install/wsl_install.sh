#!/usr/bin/env bash

# local and remote location of dotfiles
DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# get git
sudo apt-get update
sudo apt-get install git

# clone remote dotfiles dir
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# upgrade to bookworm
sudo cp ${DOTFILES}/install/sources.list /etc/apt/sources.list
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt autoremove

# install packages from packages.lst (must have unix file endings)
sudo apt-get install $(cat $DOTFILES/install/packages.lst)

# link dotfiles to home directory
source $DOTFILES/install/install.sh

# make zsh the default shell
chsh -s $(which zsh)


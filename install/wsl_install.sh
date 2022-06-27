#!/usr/bin/env bash

# set install path
DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# we need git
sudo apt-get update
sudo apt-get install git

# clone remote dotfiles dir
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# install packages from packages.lst (must have unix file endings)
sudo apt-get install $(cat $DOTFILES/install/packages.lst)

# link dotfiles
source $DOTFILES/install/install.sh


#!/usr/bin/env bash

# get latest nightly build
# SRC=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
# curl -fLo /tmp/nvim.deb $SRC
# sudo apt install /tmp/nvim.deb
SRC=https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
APP=$HOME/.local/appimage
BIN=$HOME/.local/bin
mkdir -p $APP
mkdir -p $BIN
curl -fLo $APP/nvim.appimage $SRC
ln -sf $APP/nvim.appimage $HOME/.local/bin/nvim

# install python support
# sudo apt-get update
# sudo apt-get install python3-neovim


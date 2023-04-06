#!/usr/bin/env bash

# get latest nightly build
SRC=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
curl -fLo /tmp/nvim.deb $SRC
sudo apt install /tmp/nvim.deb

# install python support
sudo apt-get update
sudo apt-get install python3-neovim


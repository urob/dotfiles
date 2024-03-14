#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# Update Debian
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove

# Install dependencies
sudo apt-get -y install curl git
sudo apt-get clean

# Clone remote dotfiles
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# Activate systemd
sudo cp "$DOTFILES/config/wsl/wsl.conf" /etc/wsl.conf

# Fix interop bug https://github.com/microsoft/WSL/issues/8843
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'

# clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " key
    [[ $key =~ ^[Yy]$ ]] && rm -rf ${f}
done

# Install Nix and start nix deamon without reloading shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# run flake in current directory, creating the home manager configuration in the same directory (instead of creating a new home-manager flake in ~/.config/home-manager)
nix run "$DOTFILES" -- init --switch "$DOTFILES"

# Need to rehash?

# make zsh the default shell
chsh -s $(which zsh)

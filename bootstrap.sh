#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles
DOTFILES_REMOTE=https://github.com/urob/dotfiles

# Update Debian
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove

# Install dependencies
sudo apt-get -y install curl git sed zsh
sudo apt-get clean
#hash -r

# Make native zsh default shell as nix-version can't be made default shell
# (and requires NixOS to be made default shell declaratively)
# https://discourse.nixos.org/t/why-does-chsh-not-work/7370
chsh -s $(which zsh)

# Clone the dotfiles repo
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${DOTFILES_REMOTE} ${DOTFILES}

# Activate systemd
sudo cp "$DOTFILES/config/wsl/wsl.conf" /etc/wsl.conf

# Fix interop bug https://github.com/microsoft/WSL/issues/8843
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'

# Disable auto-generating resolv.conf if needed
read -e -p "Disable auto-generating resolv.conf? [y/N] " key
[[ $key =~ ^[Yy]$ ]] && sudo sed -i 's/.*generateResolvConf.*/generateResolvConf=false/' /etc/wsl.conf

# Clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " key
    [[ $key =~ ^[Yy]$ ]] && rm -rf ${f}
done

# Install Nix and start nix deamon without reloading shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
    sh -s -- install --no-confirm --extra-conf "trusted-users = root ${USER}"
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Initialize home manager
nix run "$DOTFILES" -- init --switch "$DOTFILES" --impure

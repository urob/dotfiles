#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles
REMOTE=https://github.com/urob/dotfiles

if [[ "$*" == *"--rh"* ]]; then
    # RedHat family.
    sudo dnf upgrade -y
    sudo dnf install -y git util-linux-user zsh
    # TODO: Set up automatic updates.
    # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/managing_software_with_the_dnf_tool/assembly_automating-software-updates-in-rhel-9_managing-software-with-the-dnf-tool

else
    # Debian family.
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y full-upgrade
    sudo apt-get -y autoremove

    sudo apt-get -y install curl git sed zsh
    sudo apt-get clean
fi
#hash -r

# Default to native zsh, because nix shells can't be made default on standalone installs.
# https://discourse.nixos.org/t/why-does-chsh-not-work/7370
chsh -s $(which zsh)

# Fetch the dotfiles.
rm -rf ${DOTFILES}
mkdir -p ${DOTFILES}
git clone ${REMOTE} ${DOTFILES}

# Activate systemd
sudo cp "$DOTFILES/config/wsl/wsl.conf" /etc/wsl.conf

# Disable auto-generating resolv.conf if needed.
read -e -p "Disable auto-generating resolv.conf? [y/N] " key
[[ $key =~ ^[Yy]$ ]] && sudo sed -i 's/.*generateResolvConf.*/generateResolvConf=false/' /etc/wsl.conf

# Clean up existing dotfiles
files=$(find $HOME -maxdepth 1 -name ".*" -print | sort)$
for f in $files; do
    read -e -p "Delete ${f/$HOME/\~}? [y/N] " key
    [[ $key =~ ^[Yy]$ ]] && rm -rf ${f}
done

# Install Nix and start the daemon.
curl -fsSL https://install.determinate.systems/nix | sh -s -- install \
    --determinate \
    --extra-conf "eval-cores = 0" \
    --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Initialize home manager.
SYSTEM=$(nix eval --raw --impure --expr "builtins.currentSystem")
nix run "$DOTFILES" -- switch --flake "${DOTFILES}#${SYSTEM}"

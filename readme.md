## Bootstrap config

```sh
cd && bash <(curl https://raw.githubusercontent.com/urob/dotfiles/main/bootstrap.sh)
```

## Installing Nix

Note: must activate system.d. Otherwise will get:
```
error: could not set permissions on '/nix/var/nix/profiles/per-user' to 755: Operation not permitted
```

```sh
nixdot = $HOME/nixdot

# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Start nix daemon without reloading shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh


# run flake in current directory, creating the home manager configuration in the same directory (instead of creating a new home-manager flake in ~/.config/home-manager)
nix run "$nixdot" -- init --switch "$nixdot"
```

To rebuild config

```sh
# re build the configuration
home-manager switch --flake "$nixdot"
```


Troubleshooting locales one non-NixOS linux: https://nixos.wiki/wiki/Locales
TLDR: add following to .zshenv (zsh) or .profile (bash):
```
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
```

## Update inputs to flake (e.g., packages)

```nix
# update all inputs
nix flake update --flake .

# update a single flake input
nix flake lock --update-input <input>
```

## Bootstrap config

### Preliminaries (WSL only)

1. Enable `system.d`

   ```sh
   sudo sh -c 'cat << EOF > /etc/wsl.conf
   [boot]
   systemd = true

   [interop]
   enabled = true

   [automount]
   enabled = true
   options = "metadata,umask=022,fmask=011"

   EOF'
   ```

2. Fix name resolution on corporate networks

   ```sh
   # Debian 12 does not yet support net.ipv4.ping_group_range which allows non-root pings
   sudo ping www.google.com

   # Run this if name resolution fails
   sudo unlink /etc/resolv.conf
   sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

   # Prevent WSL from auto-generating resolv.conf on reboot
   sudo sh -c 'echo "[network]" >> /etc/wsl.conf'
   sudo sh -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
   ```

3. Reboot

   ```ps1
   # Run this on ps1
   wsl -t debian
   wsl -d debian
   ```

### Install config on Debian

1. Install `curl`

   ```sh
   sudo apt-get update && sudo apt-get install curl
   ```

2. Run the installer script

   ```sh
   cd && bash <(curl https://raw.githubusercontent.com/urob/dotfiles/main/bootstrap.sh)
   ```

## Manually Set Up Home Manager

```sh
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | 
  sh -s -- install --no-confirm

# Start nix daemon without reloading shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Initialize home manager in current directory
cd <path/to/flake.nix>
SYSTEM=$(nix eval --raw --impure --expr "builtins.currentSystem")
nix run . -- init --switch ".#$SYSTEM"
```

## Maintainance

- Rebuild config

  ```sh
  home-manager switch --flake <path/to/flake.nix>#<configuration>
  ```

- Update all packages

  ```sh
  # update all inputs
  nix flake update --flake <path/to/flake.nix>

  # update a single flake input
  nix flake lock --update-input <input>
  ```

## Troubleshooting

- Permission errors when creating `outOfStoreSymlinks`: see issues
  [#4692](https://github.com/nix-community/home-manager/issues/4692),
  [#9579](https://github.com/NixOS/nix/issues/9579), and PR
  [#9723](https://github.com/NixOS/nix/pull/9723)

  ```
  error:
      … while setting up the build environment

      error: getting attributes of path '/nix/store/d5w0zqag0v8wkyab59aph7v9ypkr3h6y-hm_nvim':
      Permission denied
  ```

  Workaround:

  ```sh
  # uninstall nix if already installed
  /nix/nix-installer uninstall

  # install old-stable version 2.18.1
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --nix-package-url https://releases.nixos.org/nix/nix-2.18.1/nix-2.18.1-x86_64-linux.tar.xz
  ```

- The following error occurs if `systemd` is _not_ enabled

  ```
  error: could not set permissions on '/nix/var/nix/profiles/per-user' to 755:
  Operation not permitted
  ```

- See https://nixos.wiki/wiki/Locales on how to set locales. TLDR: add the
  following to `.zshenv` (done automatically in my config):

  ```sh
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
  ```

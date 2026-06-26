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

(Not needed if using the installer script.)

```sh
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | 
  sh -s -- install --no-confirm

# Start nix daemon without reloading shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Initialize home manager in current directory
cd <path/to/flake.nix>
git submodule update --init --recursive   # fetch private content (see below)
SYSTEM=$(nix eval --raw --impure --expr "builtins.currentSystem")
nix run "git+file://$PWD?submodules=1" -- switch --flake "git+file://$PWD?submodules=1#$SYSTEM"
```

## Private content

`bin/` keeps only a couple of helper scripts; the actual dotfile content
(`bin/`, `win/`, `config/`) lives in the private repo
[`dotfiles-private`](https://github.com/urob/dotfiles-private), mounted as a git
submodule at `private/`. Because the symlink list is built from the flake's copy in
the nix store, **every build must pass `?submodules=1`** (`just build` and
`bootstrap.sh` already do) so the submodule's files are present at eval time.

Edit dotfiles in place as usual — the out-of-store symlinks point at the live working
tree, so no rebuild is needed (only adding a brand-new file requires `git add` + rebuild).
To sync both repos in one step, run `dots` (aliased as `git save`): it commits & pushes
the submodule, then bumps & pushes the pointer in the parent.

## Maintainance

- Pull the latest config, including the private submodule

  ```sh
  git -C ~/dotfiles pull && git -C ~/dotfiles submodule update --init --recursive
  ```

  `bootstrap.sh` sets `submodule.recurse true`, so on a bootstrapped install a plain
  `git pull` already updates the submodule (the second command is only needed once, to
  initialize it). On an existing clone, enable the same with
  `git -C ~/dotfiles config submodule.recurse true`. Use
  `git -C ~/dotfiles submodule update --remote --merge private` to follow the submodule's
  branch tip instead of the pinned commit.

- Rebuild config (or just `just build`)

  ```sh
  home-manager switch --flake "<path/to/flake.nix>?submodules=1#<configuration>"
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

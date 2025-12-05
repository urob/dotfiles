default:
    @just --list --unsorted

# rebuild home-manager
build:
    home-manager switch --flake .#$(nix eval --raw --impure --expr "builtins.currentSystem")

# run garbage-collector
clean:
    nix-collect-garbage --delete-old

# list installed packages
list:
    @home-manager packages | grep -v -e '-man$'

# upgrade all packages
upgrade:
    @just list > /tmp/installed.bak
    nix flake update --flake .
    @just build
    @just list > /tmp/installed
    @git diff --word-diff --unified=0 --no-index /tmp/installed.bak /tmp/installed || true

# upgrade nix
upgrade-nix:
    sudo env "PATH=$PATH" determinate-nixd upgrade
    # sudo -i nix upgrade-nix  # /root/.nix-profile/bin/nix (the daemon?)
    # sudo nix upgrade-nix   # /nix/var/nix/profiles/system/bin/nix (the cli?)

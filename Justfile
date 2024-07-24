default:
    @just --list --unsorted

# rebuild home-manager
build:
    home-manager switch --flake .

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

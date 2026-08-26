default:
    @just --list --unsorted

# rebuild home-manager (?submodules=1 pulls the private submodule into the eval)
build:
    home-manager switch --flake ".?submodules=1#$(nix eval --raw --impure --expr "builtins.currentSystem")"

# publish work: push what's already committed in private/, then bump the pointer
push:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git -C private status --porcelain)" ]; then
        echo "note: private/ has uncommitted changes; these are NOT published:"
        git -C private status --short | sed 's/^/  /'
    fi
    # Submodules sit on a detached HEAD, so a bare push has no upstream.
    git -C private push origin HEAD:main
    pinned=$(git ls-tree HEAD -- private | awk '{print $3}')
    current=$(git -C private rev-parse HEAD)
    if [ "$pinned" != "$current" ]; then
        git add private
        git commit -m "Bump private"
    else
        echo "parent: pointer already up to date"
    fi
    if [ -n "$(git log @{u}..HEAD --oneline)" ]; then
        git push
    else
        echo "parent: nothing to push"
    fi

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

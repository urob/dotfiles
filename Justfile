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
    #!/usr/bin/env bash
    set -euo pipefail
    before=$(mktemp) after=$(mktemp)
    trap 'rm -f "$before" "$after"' EXIT
    home-manager packages > "$before"
    nix flake update --flake .
    just build
    home-manager packages > "$after"
    echo
    # Split "name-version[-output]" like builtins.parseDrvName (version starts
    # at the first '-' followed by a non-letter) and strip output suffixes.
    awk '
        function parse(s) {
            if (match(s, /-[^a-zA-Z]/)) { name = substr(s, 1, RSTART - 1); ver = substr(s, RSTART + 1) }
            else { name = s; ver = "" }
            sub(/-(bin|out|lib|dev|man|doc|info)$/, "", ver)
        }
        FNR == 1 { file++ }
        {
            parse($0)
            seen[name] = 1
            if (file == 1) { old[name] = ver; inold[name] = 1 }
            else           { new[name] = ver; innew[name] = 1 }
        }
        END {
            for (n in seen) {
                if (inold[n] && innew[n] && old[n] == new[n]) continue
                note = !inold[n] ? "(new)" : !innew[n] ? "(deleted)" : ""
                rows[++k] = n; o[k] = old[n]; v[k] = new[n]; t[k] = note
                if (length(n) > wn) wn = length(n)
                if (length(old[n]) > wo) wo = length(old[n])
                if (length(new[n]) > wv) wv = length(new[n])
            }
            if (!k) { print "No package changes."; exit }
            for (i = 1; i <= k; i++)
                printf "%-" wn "s  %-" wo "s -> %-" wv "s  %s\n", rows[i], o[i], v[i], t[i]
        }
    ' "$before" "$after" | sed 's/ *$//' | sort

# upgrade nix
upgrade-nix:
    sudo env "PATH=$PATH" determinate-nixd upgrade
    # sudo -i nix upgrade-nix  # /root/.nix-profile/bin/nix (the daemon?)
    # sudo nix upgrade-nix   # /nix/var/nix/profiles/system/bin/nix (the cli?)

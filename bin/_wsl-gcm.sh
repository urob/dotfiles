# Shared WSL + Git Credential Manager detection.
# Sourced (not executed) by bootstrap.sh and bin/git-credential-wsl.

is_wsl() {
    grep -qiE 'microsoft|wsl' /proc/sys/kernel/osrelease 2>/dev/null \
        || grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
}

# Print the path to git-credential-manager.exe on stdout and return 0 if found.
detect_gcm() {
    is_wsl || return 1
    local d c
    # 1. Derive from wherever Windows git.exe lives (follows the actual install).
    if command -v git.exe >/dev/null 2>&1; then
        d=$(dirname "$(command -v git.exe)")
        for c in "$d/../mingw64/bin/git-credential-manager.exe" \
                 "$d/../mingw64/bin/git-credential-manager-core.exe"; do
            if [ -x "$c" ]; then printf '%s\n' "$c"; return 0; fi
        done
    fi
    # 2. Known install locations (Git-for-Windows + standalone GCM).
    for c in "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe" \
             "/mnt/c/Program Files (x86)/Git Credential Manager/git-credential-manager.exe" \
             "/mnt/c/Program Files/Git Credential Manager/git-credential-manager.exe"; do
        if [ -x "$c" ]; then printf '%s\n' "$c"; return 0; fi
    done
    # 3. On the Windows PATH via interop.
    if command -v git-credential-manager.exe >/dev/null 2>&1; then
        command -v git-credential-manager.exe
        return 0
    fi
    return 1
}

# useful scripts

backup_dotfiles() {
  # location of backup files/dirs relative to $HOME
  CONFIG=.config
  files=(
    ".zshenv"
    "$CONFIG/nvim/init.vim"
    "$CONFIG/tmux/tmux.conf"
    "$CONFIG/zsh/.aliases"
    "$CONFIG/zsh/.zhistory"
    "$CONFIG/zsh/.zshrc"
    "$CONFIG/zsh/completion.zsh"
    "$CONFIG/zsh/scripts.zsh"
    "$CONFIG/zsh/plugins/"
    "$CONFIG/.bashrc"
    "$CONFIG/.inputrc"
    "$CONFIG/packages.lst"
    "$CONFIG/sources.list"
  )

  # backup to $DROPBOX/home/dotfiles creating directory structure as needed
  for f in $files; do
    destination="$DROPBOX/home/dotfiles/${f:h}/"
    mkdir -p "$destination"
    cp -rpu "$HOME/$f" "$destination"
  done
}

# +--------------+
# | Wsl specific |
# +--------------+

# Start explorer in $1 (defaults to .)
e() {
    explorer.exe "${1:-.}";
}

# Stop win process
winkill() {
    powershell.exe -c "Get-Process -Name $1*"
    if read -q '?Stop all matched processes (y/n)? '; then
        powershell.exe -c "Stop-Process -Name $1*"
    fi
}

# +------+
# | WHIM |
# +------+

WHIM_ROOT_DIR="$WINHOME/dev/Whim"
WHIM_RUN_DIR="$WHIM_ROOT_DIR/src/Whim.Runner/bin/x64/Debug/net7.0-windows10.0.19041.0"

whim_build() {
    pushd $WHIM_ROOT_DIR
    whim_stop &> /dev/null
    powershell.exe -c 'dotnet build Whim.sln -p:Platform=x64'
    popd
}

whim_format() {
    pushd $WHIM_ROOT_DIR
    powershell.exe -c 'dotnet tool restore'
    powershell.exe -c 'dotnet tool run dotnet-csharpier .'
    powershell.exe -c 'dotnet tool run xstyler --recursive --d . --config ./.xamlstylerrc'
    popd
}

whim_docs_serve() {
    pushd $WHIM_ROOT_DIR
    powershell.exe -c 'dotnet tool restore'
    pushd docs
    powershell.exe -c 'dotnet docfx .\docfx.json --serve'
    popd; popd
}

whim_docs_build() {
    pushd $WHIM_ROOT_DIR/docs
    powershell.exe -c 'dotnet docfx .\docfx.json'
    popd
}

whim_start() {
    "$WHIM_RUN_DIR/Whim.Runner.exe" &
}

whim_stop() {
    powershell.exe -c 'Stop-Process -Name "Whim.Runner"'
}

whim_cdrun() {
    cd $WHIM_RUN_DIR
}

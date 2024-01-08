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

whim_start() {
    "$WHIM_RUN_DIR/Whim.Runner.exe" &
}

whim_stop() {
    powershell.exe -c 'Stop-Process -Name "Whim.Runner"'
}

whim_cdrun() {
    cd $WHIM_RUN_DIR
}

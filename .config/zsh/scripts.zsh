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


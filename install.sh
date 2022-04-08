#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles

# source 
source $DOTFILES/.zshenv

# could do something like the following to skip files in win directory
# -path "$DOTILES/win" -prune -or -type f ! -path "$DOTFILES/install.sh" -print | sort
files=$(find $DOTFILES -type d -name .git -prune -or -type f ! -path "$DOTFILES/install.sh" -print | sort)

for f in $files; do
    destination="$HOME/${f#$DOTFILES/}"
    echo installing $destination
    mkdir -p "${destination%/*}"
    ln -sf "$f" "$destination"
done

# make directories that won't necessarily be created automatically
mkdir -p $XDG_BIN_HOME
mkdir -p $XDG_LIB_HOME
mkdir -p $XDG_STATE_HOME/zsh
mkdir -p $XDG_CACHE_HOME/zsh
mkdir -p $XDG_STATE_HOME/nvim/sessions

# install diff-so-fancy
rm -rf $XDG_LIB_HOME/diffsofancy/ $XDG_BIN_HOME/diff-so-fancy
git clone --depth=1 https://github.com/so-fancy/diff-so-fancy $XDG_LIB_HOME/diffsofancy
chmod +x $XDG_LIB_HOME/diffsofancy/diff-so-fancy
ln -s $XDG_LIB_HOME/diffsofancy/diff-so-fancy $XDG_BIN_HOME/diff-so-fancy

# install gitstatus
rm -rf $GITSTATUSDIR
mkdir -p $GITSTATUSDIR
git clone --depth=1 https://github.com/romkatv/gitstatus.git $GITSTATUSDIR

#!/usr/bin/env bash

# get environment variables
DOTFILES=$HOME/dotfiles
source $DOTFILES/.zshenv

# replicate dotfiles in local home using softlinks
files=$(find $DOTFILES -type d -name .git -prune \
    -or -type f ! -path "$DOTFILES/install.sh" -print | sort)

for f in $files; do
    destination="$HOME/${f#$DOTFILES/}"
    echo installing $destination
    mkdir -p "${destination%/*}"
    ln -sf "$f" "$destination"
done

# create required directories
mkdir -p $XDG_BIN_HOME
mkdir -p $XDG_LIB_HOME
mkdir -p $XDG_STATE_HOME/zsh
mkdir -p $XDG_CACHE_HOME/zsh
mkdir -p $VIMCONFIG/sessions

# check whether command exists
function command_exists () {
    if ! command -v $1 &> /dev/null; then
        echo "$(tput setaf 1)Error: $1 is not installed.$(tput sgr0)" >&2
        exit 1
    fi
}

# install 3rd party tools, usage: get_git user project install_dir
function get_git() {
    rm -rf ${3}
    mkdir -p ${3}
    git clone --depth=1 https://github.com/${1}/${2} ${3}
}

# diff-so-fancy
$(command_exists git) || exit 1
get_git so-fancy diff-so-fancy $XDG_LIB_HOME/diffsofancy
chmod +x $XDG_LIB_HOME/diffsofancy/diff-so-fancy
ln -sf $XDG_LIB_HOME/diffsofancy/diff-so-fancy $XDG_BIN_HOME/diff-so-fancy

# gitstatus
get_git romkatv gitstatus $GITSTATUSDIR

# plug-vim
$(command_exists curl) || exit 1
curl -fLo "${VIMCONFIG}"/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qall

# reminder to reload tmux and zsh for changes to take effect
echo "$(tput setaf 2)All done. Reload tmux and zsh config for settings to take effect.$(tput sgr0)"


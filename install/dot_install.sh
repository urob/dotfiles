#!/usr/bin/env bash

# manually install dotfiles without nix

# +---------------+
# | PRELIMINARIES |
# +---------------+

# source the environment
DOTFILES=$HOME/dotfiles
source $DOTFILES/.zshenv
DOTFILES_CONFIG_HOME=$DOTFILES/${XDG_CONFIG_HOME/$HOME\/}

# create all necessary folder
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_BIN_HOME
mkdir -p $XDG_LIB_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME
mkdir -p $XDG_CACHE_HOME

# assert that dependencies for installation are fulfilled
function command_exists () {
    if ! command -v $1 &> /dev/null; then
        echo "$(tput setaf 1)Error: $1 is not installed.$(tput sgr0)" >&2
        exit 1
    fi
}
$(command_exists git) || exit 1
$(command_exists curl) || exit 1

# wrapper for git
function get_git() {
    rm -rf ${2}
    mkdir -p ${2}
    git clone --depth=1 https://github.com/${1} ${2}
}

# +------------------+
# | INSTALL DOTFILES |
# +------------------+

# find all target files
files=$(find $DOTFILES \
    -type d \( \
            -path "$DOTFILES/install" \
        -or -path "$DOTFILES/ignore" \
        -or -path "$DOTFILES/win" \
        -or -path "$DOTFILES_CONFIG_HOME/nvim/autoload" \
        -or -name .git \
        \) -prune \
    -or -type f ! \( \
            -path "$DOTFILES/install.sh" \
        \) -print | sort)

# create links to dotfiles folder
for f in $files; do
    destination="$HOME/${f#$DOTFILES/}"
    echo installing ${destination/$HOME/\~}
    mkdir -p "${destination%/*}"
    ln -sf "$f" "$destination"
done

# +---------------------+
# | INSTALL CLOUD FILES |
# +---------------------+

# search for cloud location
# [[ -z $SSH_CONNECTION ]] && source $ZDOTDIR/plugins/set_dropbox_path.sh
# if [[ -n $DROPBOX ]]; then
#     read -e -p "Install cloud files from $DROPBOX? [Y/n] " key
#     if [[ $key =~ ^[Yy]$ || -z $key ]]; then
#
#         # declare associative array that assigns each file a source
#         declare -A SOURCE
#         SOURCE["$HISTFILE"]="$DROPBOX"/home/dotfiles_cloud/zsh_history
#
#         # for each file, backup up old copy unless it's a sym link, then link to cloud
#         for f in "${!SOURCE[@]}"; do
#             echo installing ${f/$HOME/\~}
#             [[ -f $f ]] && [[ ! -L $f ]] && mv "$f" "$f".bak
#             ln -sf "${SOURCE["$f"]}" "$f"
#         done
#     fi
# fi

# +-----+
# | GIT |
# +-----+

# install diff-so-fancy
get_git so-fancy/diff-so-fancy $XDG_LIB_HOME/diffsofancy
chmod +x $XDG_LIB_HOME/diffsofancy/diff-so-fancy
ln -sf $XDG_LIB_HOME/diffsofancy/diff-so-fancy $XDG_BIN_HOME/diff-so-fancy

SRC=https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh
curl -fLo $XDG_LIB_HOME/fzf-git/fzf-git.sh $SRC --create-dirs

# +-----+
# | ZSH |
# +-----+

mkdir -p $XDG_STATE_HOME/zsh
mkdir -p $XDG_CACHE_HOME/zsh

# install gitstatus, used for prompt
get_git romkatv/gitstatus $GITSTATUS_DIR

# +------+
# | NVIM |
# +------+

mkdir -p $VIMDATA/sessions

# install plugin manager
curl -fLo "${VIMDATA}"/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qall

# autoload folder
ln -sf "$DOTFILES_CONFIG_HOME/nvim/autoload/general.vim" "$VIMDATA/site/autoload"

# +-------------+
# | WRAPPING UP |
# +-------------+

# reminder to reload tmux and zsh for changes to take effect
echo "$(tput setaf 2)All done. Reload tmux and zsh config for settings to take effect.$(tput sgr0)"


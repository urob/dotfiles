# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_LIB_HOME=$HOME/.local/lib
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.local/cache # default is ~/.cache

# Windows home path
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    pushd /mnt/c > /dev/null # avoid UNC path error, current path restored below
    export WINHOME=$(wslpath $(cmd.exe /C "echo %USERPROFILE%" | tr -d '\r'))
    popd > /dev/null
fi

# editor
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -R --use-color --mouse"

# zsh
export KEYTIMEOUT=200
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"  # fallback, overwritten in zshrc
export HISTSIZE=15000  # Maximum events for internal history
export SAVEHIST=10000  # Maximum events in history file, should be smaller
                       # than HISTSIZE to reliably prune duplicates

# fzf
export FZF_PLUG_DIR="/usr/share/doc/fzf/examples"  # see .zshrc
export FZF_GIT_DIR="XDG_LIB_HOME/fzf-git"          # see .zshrc
export FZF_VIM_DIR="/usr/share/doc/fzf/examples"   # see init.vim

export FZF_DEFAULT_COMMAND='fdfind --type f --type l --follow --hidden --min-depth 1 --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fdfind --follow --hidden --min-depth 1'
export FZF_ALT_C_COMMAND='fdfind --type d --follow --hidden --min-depth 1'

FZF_COLORS="bg+:-1,\
fg:white,\
fg+:-1,\
hl:bright-yellow,\
hl+:yellow:reverse,\
border:gray,\
label:gray,\
spinner:green,\
header:blue,\
info:green,\
separator:gray,\
pointer:yellow,\
marker:yellow,\
prompt:white"

export FZF_DEFAULT_OPTS="--height 60% \
    --color='$FZF_COLORS' \
    --info inline-right \
    --prompt '∷ ' \
    --pointer » \
    --marker ▎ \
    --preview-window='right,50%,border-sharp' \
    --bind='ctrl-/:change-preview-window(up,50%,border-bottom|hidden|)'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 50'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"
export FZF_TMUX_OPTS="-p80%,60% --border sharp --preview-window=border-left"
export _ZO_FZF_OPTS="${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} --preview 'tree -C {2} | head -n 50'"

# git
export GIT_REVIEW_BASE=main  # see gitconfig

# ruby
export GEM_HOME="$HOME/.local/gems"

# other software
export GITSTATUS_DIR="$XDG_LIB_HOME/gitstatus"  # see zshprompt
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# fixes duplication of commands when using tab-completion
# export LANG=C.UTF-8

# source session variables managed by nix
unset __HM_SESS_VARS_SOURCED
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

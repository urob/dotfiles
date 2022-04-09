#!/usr/bin/env zsh

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_LIB_HOME=$HOME/.local/lib
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.local/cache

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=15000  # Maximum events for internal history
export SAVEHIST=10000  # Maximum events in history file, should be smaller
                       # than HISTSIZE to reliably prune duplicates

# fzf
FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:red,\
prompt:gray,\
hl+:red"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--color='$FZF_COLORS' \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"

# other software
export GITSTATUSDIR="$XDG_LIB_HOME/gitstatus"  # used for zsh prompt
export VIMCONFIG="${XDG_DATA_HOME}/nvim"       # vim-plug, sessions, etc
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"


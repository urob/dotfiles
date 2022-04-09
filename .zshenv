#!/usr/bin/env zsh

# XDG
export XDG_BIN_HOME=$HOME/bin
export XDG_CONFIG_HOME=$HOME/.config
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
export HISTSIZE=15000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file, should be smaller than
                                        # HISTSIZE to reliably prune duplicates

# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'

# other software
export GITSTATUSDIR="$XDG_LIB_HOME/gitstatus"  # used for zsh prompt
export VIMCONFIG="$XDG_CONFIG_HOME/nvim"       # used in init.vim
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"


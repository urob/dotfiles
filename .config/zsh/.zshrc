# .zshrc

# set dropbox directory unless remote
[[ -z $SSH_CONNECTION ]] && source $ZDOTDIR/plugins/set_dropbox_path.sh

# set path to include local bin
export PATH=$PATH:$XDG_BIN_HOME

fpath=($ZDOTDIR/plugins $fpath)

# +------------+
# | NAVIGATION |
# +------------+

setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
# setopt EXTENDED_GLOB        # Use extended globbing syntax.

# +----------------------+
# | BRACKETED PASTE MODE |
# +----------------------+

# conflicts with fzf and gitprompt
#set zle_bracketed_paste      # Explicitly restore this zsh default
#autoload -Uz bracketed-paste-magic
#zle -N bracketed-paste bracketed-paste-magic

# +---------+
# | HISTORY |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
# setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# +--------+
# | COLORS |
# +--------+

# Overwrite ls-colors for 'other writable' directories (ow)
eval "$(dircolors -b)"
export LS_COLORS=${(S)LS_COLORS/ow=*:/ow=1;34:}

# +---------+
# | ALIASES |
# +---------+

source $ZDOTDIR/.aliases

# +---------+
# | SCRIPTS |
# +---------+

source $ZDOTDIR/scripts.zsh

# +--------+
# | PROMPT |
# +--------+

source $ZDOTDIR/plugins/prompt_urob_setup

# +---------+
# | BINDING |
# +---------+

# Use emacs bindings (resets any bindings issued before that line!)
bindkey -e

# Bind up/down to incremental history-search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "$key[Up]" history-beginning-search-backward-end
bindkey "$key[Down]" history-beginning-search-forward-end

# Microsoft word navigation
bindkey '^H' backward-kill-word    # Ctrl + Backspace
bindkey ";5C" forward-word         # Ctrl + Right
bindkey ";5D" backward-word        # Ctrl + Left
bindkey "^[[1~" beginning-of-line  # Ctrl + Home
bindkey "^[[4~" end-of-line        # Ctrl + End

# +------------+
# | COMPLETION |
# +------------+

source $ZDOTDIR/completion.zsh

# +-----+
# | FZF |
# +-----+

if (( $+commands[fzf] )); then
    # ^R completes from history, !C from dirs, ^T from files
    source $FZF_PLUG_DIR/key-bindings.zsh
    source $FZF_PLUG_DIR/completion.zsh
    # source $DOTFILES/zsh/scripts_fzf.zsh # fzf Scripts

    # Search with fzf and open selected file with Vim
    bindkey -s '^V' 'vim $(fzf);^M'
fi

# +---------+
# | MODULES |
# +---------+

autoload -Uz zcalc  # zcalc calculator

# +---------+
# | STARTUP |
# +---------+

# start/reattach to tmux session if running locally
if [[ -z $SSH_CONNECTION ]] && [ "$TMUX" = "" ]; then
    if [ "$(tmux ls | grep -v attached | wc -l)" -gt "0" ]; then
        # attach to old session
        tmux a -t "$(tmux ls | grep -v attached | cut -d ":" -f1 | head -n 1)"
    else
        # dont use exec so it's possible to run without tmux
        tmux
    fi
fi


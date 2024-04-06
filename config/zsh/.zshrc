# Only keep unique entries in $PATH, $CDPATH etc
typeset -U path cdpath fpath manpath

# Add user path dirs
for dir in "$HOME/bin" "$XDG_BIN_HOME" "$GEM_HOME/bin"; do
    [[ -d $dir ]] && path+="$dir"
done

#fpath+="$ZDOTDIR"/plugins

# Export dropbox path
[[ -z $SSH_CONNECTION ]] && source $ZDOTDIR/plugins/set_dropbox_path.sh

# Sync histfile via dropbox
if [[ -n $DROPBOX ]]; then
    CLOUD="$DROPBOX/home/dotfiles_cloud/"
    export HISTFILE="$CLOUD/zsh_history"
fi

# TODO: use zsh-defer to source slow plugins
# https://github.com/romkatv/zsh-defer

# +------------+
# | NAVIGATION |
# +------------+

# setopt AUTO_CD              # Go to folder path without using cd

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
# setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd

setopt NOCASEGLOB           # Ignore case when matching
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable
# setopt EXTENDED_GLOB        # Use extended globbing syntax

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
setopt HIST_FCNTL_LOCK           # Use system's fcntl file lock for better performance
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
# Not needed if setting right uuint for windows host mounts
eval "$(dircolors -b)"
#export LS_COLORS=${(S)LS_COLORS/ow=*:/ow=1;34:}

# +---------+
# | ALIASES |
# +---------+

source $ZDOTDIR/aliases

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

typeset -gA key

key[Backspace]="^?"
key[Ctrl+Backspace]="^H"
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Delete]="${terminfo[kdch1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[Ctrl+Left]="${terminfo[kLFT5]}"
key[Ctrl+Right]="${terminfo[kRIT5]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# Bind up/down to incremental history-search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "$key[Up]" history-beginning-search-backward-end
bindkey "$key[Down]" history-beginning-search-forward-end

# Microsoft word navigation
bindkey "$key[Ctrl+Backspace]" backward-kill-word
bindkey "$key[Ctrl+Left]" backward-word
bindkey "$key[Ctrl+Right]" forward-word
bindkey "$key[Home]" beginning-of-line
bindkey "$key[End]" end-of-line

# +------------+
# | COMPLETION |
# +------------+

source $ZDOTDIR/completion.zsh

unsetopt LIST_BEEP  # turn off autocomplete beeps
# unsetopt BEEP     # turn off all beeps

# +-----+
# | FZF |
# +-----+

if (( $+commands[fzf] )); then
    source $ZDOTDIR/fzf.zsh
fi

# +---------+
# | MODULES |
# +---------+

autoload -Uz zcalc  # zcalc calculator
autoload -Uz zmv

# +---------+
# | PYTHON  |
# +---------+

[[ -d "$HOME/micromamba" ]] && source $ZDOTDIR/python.zsh

# +---------+
# | ZOXIDE  |
# +---------+

# must be sourced after calling compinit (in completion.zsh)
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"
fi

# Completions.
if [[ -o zle ]]; then
    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # calling _path_files directly to avoid duplication issue #491
            _path_files -/
        elif [[ "${words[-1]}" == '' ]] && [[ "${words[-2]}" != "${__zoxide_z_prefix}"?* ]]; then
            \builtin local result
            # shellcheck disable=SC2086,SC2312
            if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- ${words[2,-1]})"; then
                result="${__zoxide_z_prefix}${result}"
                # shellcheck disable=SC2296
                compadd -Q "${(q-)result}"
            fi
            \builtin printf '\e[5n'
        fi
        return 0
    }

    \builtin bindkey '\e[0n' 'reset-prompt'
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete __zoxide_z
fi

# +---------+
# | STARTUP |
# +---------+

# start/reattach to tmux session if running locally on a login shell
if [[ -z $SSH_CONNECTION ]] && [[ -o login ]] && [ "$TMUX" = "" ]; then
    if [ "$(tmux ls | grep -v attached | wc -l)" -gt "0" ]; then
        # attach to old session
        tmux a -t "$(tmux ls | grep -v attached | cut -d ":" -f1 | head -n 1)"
    else
        # dont use exec so it's possible to run without tmux
        tmux
    fi
fi


#!/usr/bin/env zsh

# +---------+
# | General |
# +---------+

# if [[ -n $TMUX ]]; then
#     alias fzf="fzf-tmux -p"
# fi

_fzf_compgen_path() {
    command fdfind --follow --hidden --min-depth 1 . "$1"
}

_fzf_compgen_dir() {
    command fdfind --type d --follow --hidden --min-depth 1 . "$1"
}

# instead of defining one completion function per command, can just put them all in comprun
# _fzf_comprun() {
#     local command=$1
#     shift

#     case "$command" in
#         cd)     fdfind --type d --follow --hidden | fzf --preview 'tree -C {}' "$@";;
#         *)      fzf "$@" ;;
#     esac
# }

# ** completion
source $FZF_PLUG_DIR/completion.zsh

# git-fzf
source $FZF_GIT_DIR/fzf-git.sh

_fzf_git_fzf() {
    fzf-tmux -p80%,60% -- \
        --layout=reverse-list --multi --height=60% --min-height=20 --border sharp \
        --border-label-pos=2 \
        --color='header:italic,label:blue' \
        --preview-window='right,50%,border-left' \
        --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

# +-------+
# | Binds |
# +-------+

source $FZF_PLUG_DIR/key-bindings.zsh

fzf-vim-widget() {
  local cmd="${FZF_CTRL_V_COMMAND:-"fdfind --type f --type l --follow --hidden --min-depth 1 \
      --exclude '*.png' --exclude '*.zip' \
      --strip-cwd-prefix "}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local file="$(eval "$cmd" | FZF_DEFAULT_OPTS="--reverse --height ${FZF_TMUX_HEIGHT:-40%} \
      --preview 'bat -n --color=always {}' \
      --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_V_OPTS-}" $(__fzfcmd) -m --print0)"
  if [[ -z "$file" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="nvim -- $(echo $file | xargs -0 -o)"
  zle accept-line
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N            fzf-vim-widget
bindkey -M emacs '^V' fzf-vim-widget
bindkey -M vicmd '^V' fzf-vim-widget
bindkey -M viins '^V' fzf-vim-widget

# +-----+
# | Nix |
# +-----+

# select and activate generation
# TODO: add --bind to (1) delete selected generation, (2) delete all but newest gen, (3) rebuild from current flakes; (4) bind activate instead of making it default action, (5) just insert hash on CLI as default action
# add another command to switch dev environs
fzfnix() {
    local gen="$(home-manager generations | $(__fzfcmd) --with-nth="..5" | awk '{print $7}')"
    "${gen}"/activate
}

# +-----+
# | Git |
# +-----+

# # Complete "git foo **<tab>" with commit sha
# _fzf_complete_git() {
#     _fzf_complete --ansi --no-sort --tiebreak=index --with-nth=2.. --layout=reverse-list \
#         --multi -- "$@[-1]" < <(
#             git log --color=always --format="%C(auto)%h %s %C(bold)(%cr)%C(auto)%d"
#         )
# }

# _fzf_complete_git_post() {
#     sed "s/ .*//"
# }

# # Git log browser
# fgl() {
#     git log --color=always --format="%C(auto)%h %s %C(bold)(%cr)%C(auto)%d" "$@" |
#         command fzf --ansi --no-sort --layout=reverse-list --with-nth=2.. \
#         --tiebreak=index --bind=ctrl-s:toggle-sort \
#         --bind "ctrl-m:execute:
#                     (grep -o '[a-f0-9]\{7\}' | head -1 |
#                     xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
#                     {}
# FZF-EOF"
# }


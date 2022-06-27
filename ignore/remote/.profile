# read by the following login shells: sh, ksh, bash (if no .bash_profile is found)

# start locally installed zsh when bash is default
[ -f $HOME/bin/zsh ] && exec $HOME/bin/zsh -l

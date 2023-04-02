
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="/home/urob/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="/home/urob/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/home/urob/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "/home/urob/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="/home/urob/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<

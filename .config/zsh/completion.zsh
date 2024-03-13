# zsh completion configuration

# +---------+
# | General |
# +---------+

# Use modern completion system
autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' use-compctl false

# Include hidden files in search
_comp_options+=(globdots)

# +---------+
# | Options |
# +---------+

setopt COMPLETE_IN_WORD  # Complete from both ends of a word
setopt GLOB_COMPLETE     # Show autocompletion menu with globs
setopt LIST_PACKED       # Print matches in columns with different widths

# +---------+
# | zstyles |
# +---------+

# Completion modes
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands which use it
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*' verbose true
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Add colors for files and directories (disable for other searches)
zstyle ':completion:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# Try case insensitive search if there is no exact match
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Only display some tags for the command cd, complete 'cd -' with options
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' complete-options true

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Ignore windows binaries when completing commands
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '*.???|*.ax|*.conf|*.config|*.h|*.json|*.Manifest|*.\(old\)|*.ps1xml|*.rs|*.sbin|*.so|*.uninstall|*.xslt'

zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false


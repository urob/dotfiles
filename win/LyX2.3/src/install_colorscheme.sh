#!/usr/bin/env bash

# usage: ./install_colorscheme.sh colorscheme preferences
colorscheme=$1
preferences=$2

# backup preferences
cp "$preferences" "$preferences".bak

lead='^# COLOR SECTION'  # beginning of color section block
tail='^# .* ##########'  # beginning of next block

sed -i -e "
   /$lead/,/$tail/!b  # match color section block, read in rest of file as usual
   //!d               # delete matched block
   /$lead/ {          # at beginning of matched block: append # + empty line, read in colorscheme, and append empty line + #
    a #
    a
    r "$colorscheme"
    a
    a #
   }
" "$preferences"

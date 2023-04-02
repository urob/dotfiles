#!/usr/bin/env bash

# Recursively ignore files / directories in dropbox as detailed here:
#   https://help.dropbox.com/sync/ignored-files
#
# Usage:
#   "dropbox_ignore.sh path" to ignored directory / file
#   "dropbox_ignore.sh -c path" to un-ignore directory / file

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--clear)
            CLEAR="true"
            ;;

        *)
            file="$(wslpath -w $1)"

    esac
    shift
done


if [[ $CLEAR = true ]]
then
    echo "Un-ignoring $file"
    powershell.exe -Command Clear-Content -Path "$file" -Stream com.dropbox.ignored
else
    echo "Ignoring $file"
    powershell.exe -Command Set-Content -Path "$file" -Stream com.dropbox.ignored -V 1
fi



{ pkgs, config, lib, ... }:
let
in
{
    homeFiles = let
        ln = config.lib.file.mkOutOfStoreSymlink;
        lndir = path: link: builtins.listToAttrs (
            map (file: {
                name = "${link}/${lib.path.removePrefix (/. + path) (/. + file)}";
                value = { source = ln "${file}"; };
            }) (lib.filesystem.listFilesRecursive path)
        );
        in
            attrs: lib.attrsets.concatMapAttrs (target: value:
            if value.outOfStoreSymlink or false
            then
                if value.recursive or false
                then
                    # Recursive version of mkOutOfStoreSymlink
                    lndir value.source target
                else
                    # Same as mkOutOfStoreSymlink
                    { "${target}" = {source = ln value.source; }; }
            else
                # Use default handler for in-store links
                { "${target}" = value; }
        ) attrs;
}

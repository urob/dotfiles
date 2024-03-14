{ config, pkgs, lib, ... }:
{
  # Add out-of-store-symlinks to given attrSet. Usage:
  # home.file = linkHomeFiles "/home/urob/dotfiles/" {
  #   .config = { source = "config"; outOfStoreSymlink = true; recursive = true; };
  # };
  linkHomeFiles =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
      lndir = path: link: builtins.listToAttrs (
        map
          (file: {
            name = "${link}/${lib.path.removePrefix (/. + path) (/. + file)}";
            value = { source = ln "${file}"; };
          })
          (lib.filesystem.listFilesRecursive path)
      );
      rmopts = attrs: builtins.removeAttrs attrs [ "source" "recursive" "outOfStoreSymlink" ];
    in
    root: fileAttrs: lib.attrsets.concatMapAttrs
      (name: value:
        if value.outOfStoreSymlink or false
        then
          if value.recursive or false
          then
          # Recursive version of mkOutOfStoreSymlink
            lib.attrsets.mapAttrs (_: attrs: attrs // rmopts value) (lndir "${builtins.toString root}/${value.source}" name)
          else
          # Same as mkOutOfStoreSymlink
            { "${name}" = { source = ln "${builtins.toString root}/${value.source}"; } // rmopts value; }
        else
        # Use default handler for in-store links
          { "${name}" = value; }
      )
      fileAttrs;
}

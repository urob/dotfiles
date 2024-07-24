# This function adds and interpretes outOfStoreSymlink option to home.file attribute sets.
#
# Usage:
#   home.file = mkSymlinkAttrs {
#     .foo = { source = "foo"; outOfStoreSymlink = true; recursive = true; };
#     .bar = { source = "foo/bar"; outOfStoreSymlink = true; };
#   };
{ pkgs, hm, context, runtimeRoot, ... }:

let
  inherit (pkgs) lib;

  # Swap a path inside the nix store with the same path in runtimeRoot
  runtimePath = path:
    let
      rootStr = toString context; # context is the `self` passed to flake outputs
      pathStr = toString path;
    in
    assert lib.assertMsg (lib.hasPrefix rootStr pathStr)
      "${pathStr} does not start with ${rootStr}";
    runtimeRoot + lib.removePrefix rootStr pathStr;

  # Make outOfStoreSymlink against runtimeRoot. This replicates
  # config.lib.file.mkOutOfStoreSymlink as_mkOutOfStoreSymlink and wraps it to
  # replace the target path in the nix store with the original target path
  # inside runtimeRoot. This is necessary because flakes always live in the nix
  # store.
  mkOutOfStoreSymlink =
    let
      _mkOutOfStoreSymlink = path:
        let
          pathStr = toString path;
          name = hm.strings.storeFileName (baseNameOf pathStr);
        in
        pkgs.runCommandLocal name { } ''ln -s ${lib.strings.escapeShellArg pathStr} $out'';
    in
    file: _mkOutOfStoreSymlink (runtimePath file);

  # Recursively make OutOfStoreSymlinks for all files inside path.
  mkRecursiveOutOfStoreSymlink = path: link:
    builtins.listToAttrs (
      map
        (file: {
          name = link + "${lib.removePrefix (toString path) (toString file)}";
          value = { source = mkOutOfStoreSymlink file; };
        })
        (lib.filesystem.listFilesRecursive path)
    );

  # Remove custom attributes from attribute set.
  rmopts = attrs: builtins.removeAttrs attrs [ "source" "recursive" "outOfStoreSymlink" ];

in fileAttrs: lib.attrsets.concatMapAttrs
  (
    name: value:
    # Make outOfStoreSymlinks
    if value.outOfStoreSymlink or false
    then
      if value.recursive or false
      then
        lib.attrsets.mapAttrs
          (_: attrs: attrs // rmopts value)
          (mkRecursiveOutOfStoreSymlink value.source name)
      else { "${name}" = { source = mkOutOfStoreSymlink value.source; } // rmopts value; }
    # Handle all other cases as usual
    else { "${name}" = value; }
  )
  fileAttrs

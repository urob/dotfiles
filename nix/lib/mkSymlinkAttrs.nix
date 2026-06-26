# This function adds and interpretes outOfStoreSymlink option to home.file attribute sets.
#
# Usage:
#   home.file = mkSymlinkAttrs {
#     .foo = { source = "foo"; outOfStoreSymlink = true; recursive = true; };
#     .bar = { source = "foo/bar"; outOfStoreSymlink = true; };
#   };
#
# For recursive entries, `source` may be a list of paths; they are expanded
# file-by-file and merged under the same key (e.g. merge two bin/ dirs).
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
  # inside runtimeRoot. This is necessary because flakes live in the nix store.
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

  # Normalize `source` to a list so a single key can merge several sources.
  toSourceList = s: if builtins.isList s then s else [ s ];
  mergeAttrs = builtins.foldl' (a: b: a // b) { };

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
          (mergeAttrs (map
            (src: mkRecursiveOutOfStoreSymlink src name)
            (toSourceList value.source)))
      else { "${name}" = { source = mkOutOfStoreSymlink value.source; } // rmopts value; }
    # Handle all other cases as usual
    else { "${name}" = value; }
  )
  fileAttrs

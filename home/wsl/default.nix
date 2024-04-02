{ pkgs, ... }: {
  home.packages = [
    (import ./win32yank.nix { inherit pkgs; })
  ];
}

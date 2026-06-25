# TODO
# - check if need to create dirs: XDG_*, XDG_[CACHE|STATE]_HOME/zsh
# - partially manage zsh?
{ cfg, lib, pkgs, ... }:

let
  inherit (cfg) username homeDirectory;

in
{
  # Mostly version of auto-generated configs.
  home.stateVersion = "25.11";

  # About me
  home = { inherit username homeDirectory; };

  # Workaround home-manager bug.
  # - https://github.com/nix-community/home-manager/issues/2033
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };

  # Import sub modules
  imports = [ ./file.nix ./packages.nix ./vim.nix ];

  # Options for non-nixOS linux
  # targets.genericLinux = true;

  # TODO: no effect unless xdg is enabled
  # xdg.configFile = { ... } // (linkChildren ./dotConfig "${config.xdg.configHome}/lf");
  # xdg.enable = true;
  # xdg.mimeApps.enable;  # manage $XDG_CONFIG_HOME/mimeapps.list, can be tweaked with various properties
  xdg.cacheHome = "${homeDirectory}/.local/cache";

  home.sessionVariables = {
    # Fix locales, see https://nixos.wiki/wiki/Locales
    LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

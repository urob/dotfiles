# TODO
# - check if need to create dirs: XDG_*, XDG_[CACHE|STATE]_HOME/zsh
# - partially manage zsh?
{ config, context, ... }:
let
  inherit (context.cfg) username homeDirectory;
  inherit (config.home) profileDirectory;
in
{
  # Home-manager version
  home.stateVersion = "23.11";

  # About me
  home = { inherit username homeDirectory; };

  # Import sub modules
  imports = [ ./symlinks.nix ./programs ./wsl ];

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

# TODO
# - check if need to create dirs: XDG_*, XDG_[CACHE|STATE]_HOME/zsh
# - partially manage zsh?
# - partially outsource vim-plugs? switch to lazy?
# - currently need to manually build vim plugs after first install

{
  config,
  pkgs,
  lib,
  # username, # TODO: inherit username etc via inputs instead of model specs?
  ...
}: let
  homeDirectory = config.home.homeDirectory;
  profileDirectory = config.home.profileDirectory;
  username = config.home.username;

  utils = import ./utils.nix {inherit config pkgs lib;};
  dotfiles = "${homeDirectory}/dotfiles";
  vimData = "${homeDirectory}/.local/share/nvim";

in {
  # Import sub modules
  imports = [./pkgs.nix];

  # Set Home Manager version, must be compatible with config
  home.stateVersion = "23.11";

  # Link dotfiles
  home.file = utils.linkHomeFiles dotfiles {
    "bin" = {
      source = "bin";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config" = {
      source = "config";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".ssh" = {
      source = "config/ssh";
      outOfStoreSymlink = true;
      recursive = true;
    };

    "${vimData}/site/autoload" = {
      source = "config/nvim/autoload";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".editorconfig" = {
      source = "config/editorconfig/config";
      outOfStoreSymlink = true;
    };

    ".zshenv" = {
      source = "config/zsh/.zshenv";
      outOfStoreSymlink = true;
    };

    ".profile".text = ''. "${profileDirectory}/etc/profile.d/hm-session-vars.sh" '';
  };

  # xdg.configFile = { ... } // (linkChildren ./dotConfig "${config.xdg.configHome}/lf");
  # xdg.enable = true;
  # xdg.mimeApps.enable;  # manage $XDG_CONFIG_HOME/mimeapps.list, can be tweaked with various properties

  # Create necessary directory structure
  systemd.user.tmpfiles.rules = [
    "d ${vimData}/sessions 0755 ${username}"
  ];

  # TODO: no effect unless xdg is enabled
  xdg.cacheHome = "${homeDirectory}/.local/cache";

  home.sessionVariables = {
    # Fix locale, see https://nixos.wiki/wiki/Locales
    LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive";

    # Location of gitstatus
    GITSTATUS_DIR = "${profileDirectory}/share/gitstatus";

    # Location of fzf plugins
    FZF_PLUG_DIR = "${profileDirectory}/share/fzf";
    FZF_GIT_DIR = "${profileDirectory}/share/fzf-git-sh";
    FZF_VIM_DIR = "${profileDirectory}/share/nvim/site/plugin";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

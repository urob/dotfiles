{ config, pkgs, cfg, ... }:

let
  inherit (config.home) username homeDirectory;
  vimData = "${homeDirectory}/.local/share/nvim";

  mkSymlinkAttrs = import ../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib; # same as: inherit (cfg.context.inputs.home-manager.lib) hm;
  };

in
{
  # Create directories that are expected by dotfiles
  systemd.user.tmpfiles.rules = [
    "d ${vimData}/sessions 0755 ${username}"
  ];

  # Symlink dotfiles
  home.file = mkSymlinkAttrs {
    "bin" = {
      source = ../bin;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config" = {
      source = ../config;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".ssh" = {
      source = ../config/ssh;
      outOfStoreSymlink = true;
      recursive = true;
    };

    "${vimData}/site/autoload" = {
      source = ../config/nvim/autoload;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".editorconfig" = {
      source = ../config/editorconfig/config;
      outOfStoreSymlink = true;
    };

    ".zshenv" = {
      source = ../config/zsh/.zshenv;
      outOfStoreSymlink = true;
    };

    # ".profile".text = ''. "${profileDirectory}/etc/profile.d/hm-session-vars.sh" '';
  };
}

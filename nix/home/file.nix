{ config, pkgs, cfg, ... }:

let
  inherit (config.home) username homeDirectory;
  vimData = "${homeDirectory}/.local/share/nvim";
  private = ../../private; # repo-root/private submodule

  mkSymlinkAttrs = import ../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib; # same as: cfg.context.inputs.home-manager.lib.hm;
  };

in
{
  # Create directories that are expected by dotfiles
  systemd.user.tmpfiles.rules = [
    "d ${vimData}/sessions 0755 ${username}"  # TODO: do this from within vim config
  ];

  # Symlink dotfiles. The public repo keeps a thin bin/ (helper scripts only);
  # everything else lives in the private submodule under private/. The public
  # and private bin/ are merged into ~/bin by passing both as a source list.
  # (Building this flake requires `?submodules=1` so the submodule content is
  # present in the store at eval time.)
  home.file = mkSymlinkAttrs {
    "bin" = {
      source = [ ../../bin (private + "/bin") ];
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config" = {
      source = private + "/config";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".ssh" = {
      source = private + "/config/ssh";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".claude" = {
      source = private + "/config/claude";
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".editorconfig" = {
      source = private + "/config/editorconfig/config";
      outOfStoreSymlink = true;
    };

    ".zshenv" = {
      source = private + "/config/zsh/.zshenv";
      outOfStoreSymlink = true;
    };

    # ".profile".text = ''. "${profileDirectory}/etc/profile.d/hm-session-vars.sh" '';
  };
}

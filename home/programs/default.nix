{ config, pkgs, ... }:
let
  inherit (config.home) profileDirectory;
in
{
  imports = [ ./vim.nix ];

  home.packages = with pkgs; [
    # General packages for development and system management
    bat
    broot
    # coreutils
    eza
    # findutils
    fd
    fzf
    fzf-git-sh
    htop
    just
    lf
    # man
    ripgrep
    sd
    tldr
    tmux
    tree
    zip
    zoxide
    zsh
    # zsh-fzf-tab -- add manually or manage shell via nix

    # Basic network tools
    # curl
    openvpn3
    # rsync
    # ssh

    # Git
    diff-so-fancy
    git
    # git-crypt # encrypt secrets inside repo, best used alongside gpg
    gitstatus # fast git-status used in my prompt
    pre-commit
    tig

    # Development tools
    clang-tools # bundles clang-format, alternatively use clang
    direnv
    # nix-direnv # replace built-in use_nix and use_flake with versions that persist garbage-collection
    glow
    # gcc # also clangStdenv? # similar to build-essentials in debian
    # some markdown driver? which?
    # fuse # or fuse3? or is this part of fuse-overlayfs?
    # fuse-overlayfs # TODO: is this automatically installed by podman?
    podman
    podman-compose

    # Python
    micromamba
    # pipx
    python3
    unstable.ruff


    # Formatters and linters
    # csharpier # pulls in all tooling
    # matlab-formatter-vscode # n/a
    alejandra # opinionated nix formatter
    nixpkgs-fmt # default nix formatter for nixpkgs
    deadnix # find unused nix attributes
    statix # nix linter
    prettierd
    shfmt # shell formatter
    stylua # lua formatter
  ];

  # Export install paths referenced in dotfiles
  home.sessionVariables = {
    GITSTATUS_DIR = "${profileDirectory}/share/gitstatus";

    FZF_PLUG_DIR = "${profileDirectory}/share/fzf";
    FZF_GIT_DIR = "${profileDirectory}/share/fzf-git-sh";
    FZF_VIM_DIR = "${profileDirectory}/share/nvim/site/plugin";
  };
}

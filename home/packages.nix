{ config, pkgs, ... }:
let
  inherit (config.home) profileDirectory;
in
{
  imports = [ ./vim.nix ];

  home.packages = with pkgs; [
    # Core packages, provided by Debian
    # coreutils # or uutils-coreutils-noprefix for rust version
    # findutils
    # man
    # curl
    # rsync
    # ssh

    # General packages for development and system management
    bat
    # broot
    eza
    fd
    unstable.fzf
    unstable.fzf-git-sh
    htop
    just
    yazi
    ripgrep
    sd
    tldr
    tmux
    tree
    zip
    unstable.zoxide
    zsh
    # zsh-fzf-tab -- add manually or manage shell via nix

    # Basic network tools
    openvpn3

    # Git
    diff-so-fancy
    git
    gitstatus # fast git-status used in my prompt
    git-absorb
    pre-commit
    tig
    # git-crypt # encrypt secrets inside repo, best used alongside gpg

    # Development tools
    # clang-tools # bundles clang-format, alternatively use clang
    direnv
    nix-direnv
    # glow
    # gcc # also clangStdenv? # similar to build-essentials in debian
    # some markdown driver? which?

    # fuse # or fuse3? or is this part of fuse-overlayfs?
    # fuse-overlayfs # is this automatically installed by podman?
    # podman
    # podman-compose

    # Python
    # unstable.micromamba
    # pipx
    python3
    # poetry
    unstable.ruff
    unstable.uv


    # Formatters and linters
    # csharpier # pulls in all tooling
    # matlab-formatter-vscode # n/a
    alejandra # opinionated nix formatter
    unstable.nixfmt-rfc-style
    nixpkgs-fmt # default nix formatter for nixpkgs
    deadnix # find unused nix attributes
    statix # nix linter
    prettierd
    shfmt # shell formatter
    stylua # lua formatter
    clang-tools # c/c++ formatter
    yamlfix
    yamlfmt
  ];

  # Export install paths referenced in dotfiles
  home.sessionVariables = {
    GITSTATUS_DIR = "${profileDirectory}/share/gitstatus";

    FZF_PLUG_DIR = "${profileDirectory}/share/fzf";
    FZF_GIT_DIR = "${profileDirectory}/share/fzf-git-sh";
    FZF_VIM_DIR = "${profileDirectory}/share/nvim/site/plugin";
  };
}

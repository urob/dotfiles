{ pkgs, ... }:

{
  # Packages that should be installed to the user profile.
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
    lf
    # man
    neovim
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
    gitstatus
    pre-commit
    tig

    # Development tools
    clang-tools # bundles clang-format, alternatively use clang
    direnv
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
    ruff

  # WSL
  # xsel
  ];
}

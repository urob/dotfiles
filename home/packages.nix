{ config, pkgs, ... }:
let
  inherit (config.home) profileDirectory;
in
{
  imports = [ ./vim.nix ];

  home.packages = with pkgs; [
    bat
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
    # zsh-fzf-tab -- add manually or manage shell via nix

    openvpn3

    diff-so-fancy
    git
    gitstatus # for my zsh prompt
    git-absorb
    gh
    pre-commit
    tig
    # git-crypt # encrypt secrets inside repo, best used alongside gpg

    direnv
    nix-direnv

    python3
    unstable.ruff
    unstable.uv

    # Nix formatter and linter.
    alejandra
    unstable.nixfmt-rfc-style
    deadnix
    statix

    # Other formatter and linter.
    harper
    prettierd
    shfmt
    stylua
    clang-tools
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

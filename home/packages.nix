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
    # zsh
    # zsh-fzf-tab -- add manually or manage shell via nix

    openvpn3

    diff-so-fancy
    git
    gitstatus # fast git-status used in my prompt
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

    # Formatters and linters
    # csharpier # pulls in all tooling
    # matlab-formatter-vscode # n/a
    alejandra # opinionated nix formatter
    unstable.nixfmt-rfc-style
    nixpkgs-fmt # default nix formatter for nixpkgs
    deadnix # find unused nix attributes
    harper # grammar checker
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

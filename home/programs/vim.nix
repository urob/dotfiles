{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # package = pkgs.unstable.neovim-unwrapped;
    plugins = with pkgs.unstable.vimPlugins; [
      # Colorscheme
      onedark-nvim

      # Core plugins
      # comment-nvim # native in nightly
      fzf-vim
      quickfix-reflector-vim
      indent-blankline-nvim
      vim-matchup
      vim-repeat
      vim-subversive
      vim-surround
      vim-tmux-navigator
      # vim-zoom TODO: make flake
      virt-column-nvim
      which-key-nvim

      # Git
      conflict-marker-vim
      vim-fugitive
      gitsigns-nvim

      # Treesitter
      nvim-treesitter.withAllGrammars
      # nvim-treesitter-refactor
      nvim-treesitter-textobjects
      # nvim-ts-context-commentstring # native in nightly

      # Lazy-loaded plugins
      { optional = true; plugin = markdown-preview-nvim; }
      { optional = true; plugin = nerdtree; }
      { optional = true; plugin = vim-mundo; }
      { optional = true; plugin = conform-nvim; }
    ];
  };
}

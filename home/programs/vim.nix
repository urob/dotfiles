{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      onedark-nvim

      # Core plugins
      comment-nvim # or vim-commentary
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
      nvim-ts-context-commentstring

      # Lazy-loaded plugins
      { optional = true; plugin = markdown-preview-nvim; }
      { optional = true; plugin = nerdtree; }
      { optional = true; plugin = vim-mundo; }
      { optional = false; plugin = formatter-nvim; }
    ];
  };
}

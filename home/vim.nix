{ pkgs, ... }:
let
  jb-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "jb-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nickkadutskyi";
      repo = "jb.nvim";
      rev = "c935e135d8ddb89db424835b4b1e7d4fb5432129";
      hash = "sha256-USVd24JbabBJoK2aTSc50l3Usho+EdPkH3ch6rZSsD8=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    plugins = with pkgs.unstable.vimPlugins; [
      # Colorschemes
      catppuccin-nvim
      jb-nvim
      onedark-nvim
      papercolor-theme
      zenbones-nvim

      # Core plugins
      fzf-vim
      quickfix-reflector-vim  # edit quickfix entries to change actual file (eg, %s/foo/bar)
      vim-matchup
      vim-repeat
      vim-subversive  # operator motion for substituting from yank register
      vim-surround  # operator motions for adding, changing and deleting (,[,{, etc
      vim-tmux-navigator
      which-key-nvim
      zen-mode-nvim

      lualine-nvim
      nvim-web-devicons

      # Indent and virtual column guides
      indent-blankline-nvim
      virt-column-nvim

      nvim-colorizer-lua

      # Git
      conflict-marker-vim
      vim-fugitive
      gitsigns-nvim

      # Lsp
      nvim-lspconfig

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects  # textobjects for classes, functions, parameters, etc

      copilot-vim
      render-markdown-nvim
      plenary-nvim # required for codecompanion
      { optional = true; plugin = codecompanion-nvim; }

      # Lazy-loaded plugins
      { optional = true; plugin = conform-nvim; }
      { optional = true; plugin = markdown-preview-nvim; }
      { optional = true; plugin = nerdtree; }
      { optional = true; plugin = vim-mundo; }
    ];
  };
}

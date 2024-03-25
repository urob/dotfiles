" +----------+
" | VIM-PLUG |
" +----------+

" Brief help:
" :source %         - reload config to update plugins
" :PlugInstall      - install plugins
" :PlugUpdate       - update plugins
" :PlugClean[!]     - remove unlisted plugins (! will skip confirmation)
" :PlugUpgrade      - upgrade vim-plug itself
" :PlugStatus       - check status of plugins

call plug#begin("$VIMDATA/plugged")

Plug 'navarasu/onedark.nvim'            " colorschemes
Plug 'sainnhe/everforest'
Plug 'romainl/apprentice'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'junegunn/fzf.vim'                " fzf wrapper [lua: telescope.nvim]
Plug 'andymass/vim-matchup'            " match more stuff with %
Plug 'tpope/vim-commentary'            " easy commenting with gc(c)
Plug 'tpope/vim-surround'              " surround text with deliminators. Eg ds( cs( ysiw(
Plug 'tpope/Vim-repeat'                " make . work with plugins http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
Plug 'svermeulen/vim-subversive'       " substitute text with yank register
Plug 'dhruvasagar/vim-zoom'            " tmux-like zoom for splits
Plug 'christoomey/vim-tmux-navigator'  " navigate btwn vim splits & tmux panes
Plug 'editorconfig/editorconfig-vim'   " respect editorconfig defaults in vim
" Plug 'Yggdroot/indentLine'             " display indentation lines
Plug 'lukas-reineke/indent-blankline.nvim'  " display indentation lines
Plug 'lukas-reineke/virt-column.nvim'  " display textwidth lines
Plug 'stefandtw/quickfix-reflector.vim' " make quickfix window editable

" Git
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'mhinz/vim-signify'               " show git diff in the left gutter [lua: sigsigns]
Plug 'rhysd/conflict-marker.vim'       " highlight and navigate conflicts

" Navigate undo tree
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}

" File navigation
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}  " lua: neo-tree

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" if install error, run after installing :call mkdp#util#install()
" Plug 'preservim/vim-markdown'       " enhanced syntax + more

" Python
" Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }    " semantic syntax highlighting
" Plug 'Vimjas/vim-python-pep8-indent'  " PEP8 compliant indenting
" Plug 'neovim/nvim-lspconfig'          " native lsp server
" Plug 'dense-analysis/ale'             " linting platform, note: nvim has new builtin support

" Python integration
" Plug 'jpalardy/vim-slime'         " send code to terminal
" Plug 'dccsillag/magma-nvim'       " modern full integration of Jupyter

" Latex
" Use texlab-lsp server: https://github.com/latex-lsp/texlab
" Checkout nvim's lsp config: https://github.com/neovim/nvim-lspconfig
"                             https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
" Give tectonic a try? https://tectonic-typesetting.github.io/en-US/
" Plug 'lervag/vimtex'              " modern latex plugin

" Misc
" Plug 'w0rp/ale'                   " linting platform
" Plug 'SirVer/ultisnips'           " snippets stuff
" Plug 'honza/vim-snippets'         " snippets stuff
" Plug 'godlygeek/tabular'          " align stuff (eg markdown tables)
" Plug 'reedes/vim-wordy'           " verify quality of writting (see :Wordy)
" Plug 'rhysd/vim-grammarous', { 'for': 'markdown' } " show grammar mistakes

call plug#end()

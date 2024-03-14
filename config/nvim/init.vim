" File location: ~/.config/nvim/ | %USERPROFILE%/Local/nvim/
" Path to Vimfiles, set by shell under unix
if has("win32")
    let $VIMDATA=$USERPROFILE . '/AppData/Local/nvim'
    " *** Setup steps on Windows:
    " * run in powershell: choco fzf
    " * create 'autoload', 'fzf_plugin', 'plugged' dirs in %USERPROFILE%/Local/nvim/
    " * save https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim to fzf_plugin
    let $FZF_VIM_DIR=$VIMDATA . '/fzf_plugin'
endif

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
Plug 'tpope/Vim-repeat'                " make . work with plugins
    " http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
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

" +----------------+
" | Global options |
" +----------------+

if (has("termguicolors"))
    set termguicolors        " truecolor support
endif
syntax on

silent! colorscheme onedark  " don't choke if colorscheme does not exist

set title mouse=a            " show title + terminal mouse support
set number relativenumber    " show relative linenumbers
set keymodel=startsel        " shift + movement starts visual mode
set scrolloff=3              " keep cursor 3 lines of edge when scrolling

set clipboard+=unnamedplus   " use global clipboard
set autowrite                " write automatically when quitting buffer
set undofile                 " persistent undo
set fileformats=unix,dos     " default to unix fileformat on all platforms

" set textwidth=88             " default textwidth of 88 columns
" set colorcolumn=+1           " color column at textwidth+1
" set colorcolumn=89           " color column without linebreak

set autoindent smartindent   " automatic indentation based on cinwords
set et sw=4 ts=4 sts=-1      " expand all tabs to spaces and set shift/tabwidth, dominated by editorconfig
set shiftround               " > shifts to multiples of 4 spaces, not +4

set ignorecase smartcase     " search ignores cases unless uppercase
set completeopt+=longest     " completion insert longest common matched text

set diffopt+=vertical        " use vertical splits for diff

set pastetoggle=<F2>         " use F2 to toggle pastemode

" Formatting symbols
set list
set listchars+=tab:▸\        " tab
set listchars+=trail:·       " trailing spaces, leading spaces are blank
set listchars+=extends:>     " last col of long lines when line wrap is off
set listchars+=precedes:<    " first col of long lines when line wrap is off
set listchars+=nbsp:%        " non-breakable space character
" set listchars+=eol:⏎         " end-of-line

" language en                  " ignore system language
set spelllang=en_us            " always use English for spelling

" Set ripgrep for grep program
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-ignore\ --hidden\ --follow\ --glob="!.git/*"
endif

function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>) | cfirst
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>) | lfirst

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" augroup quickfix
"     autocmd!
"     autocmd QuickFixCmdPost cgetexpr cwindow
"     autocmd QuickFixCmdPost lgetexpr lwindow
" augroup END

" +---------+
" | autocmd |
" +---------+

" Clear all autocmds created in vimrc
augroup vimrc
    autocmd!
augroup END

" Return to last edit position when opening files
autocmd vimrc BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g`\"" | endif

" Trigger 'autoread' when files change on disk
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() != 'c' | checktime | endif

" Notification after file change
autocmd vimrc FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Highlight current line in insert mode
autocmd vimrc InsertEnter * set cursorline
autocmd vimrc InsertLeave * set nocursorline

" Writing
autocmd vimrc FileType markdown,latex,text
    \ setlocal spell spelllang=en_us norelativenumber

" Git commits
autocmd vimrc FileType gitcommit
    \ setlocal spell spelllang=en_us norelativenumber textwidth=72 colorcolumn=51,+1

" ZMK keymaps
autocmd vimrc BufNewFile,BufRead *.keymap set syntax=c

" xaml
autocmd vimrc BufNewFile,BufRead *.xaml set syntax=xml

" +------------+
" | statusline |
" +------------+

set laststatus=2
set statusline=%<                           " truncate here if needed
set statusline+=%f\                         " file + path relative to current dir
set statusline+=%h%w%m%r                    " help, preview, modified, readonly
set statusline+=%{FugitiveStatusline()}     " git status
set statusline+=%([%{&fenc=='utf-8'?'':&fenc.'>'.&enc}]%)   " file encoding if not utf-8
set statusline+=%([%{&ff=='unix'?'':&ff}]%) " file format if not unix
set statusline+=%=                          " hfill
set statusline+=%-14.(%l,%c%)\              " line:column
set statusline+=%P                          " top/bottom

" +-----------------+
" | General mapping |
" +-----------------+

" configure leader key
let mapleader = ","
let maplocalleader = ","

" better movements with Colemak DH
noremap j h
noremap k j
noremap h k

" turn off highlighting of search results
nnoremap <silent> <c-c> <Cmd>noh<cr>

" Indent without killing the selection in VISUAL mode
xnoremap < <gv
xnoremap > >gv

" location & quickfix
" nnoremap <silent> <leader>l :call general#ToggleList("Location List", 'l')<CR>
nnoremap <silent> <leader>q :call general#ToggleList("Quickfix List", 'c')<CR>
nnoremap <leader>m :cnext<CR>
nnoremap <leader>j :cprevious<CR>
" nnoremap <leader>lj :lnext<CR>
" nnoremap <leader>lk :lprevious<CR>

" toggle between absolute -> relative line number
nnoremap <leader>n <Cmd>set relativenumber!<CR>

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" escape to normal mode and write unsaved changes with <S-CR>, won't work in VT
"inoremap <s-cr> <esc>
"nnoremap <silent><s-cr> <Cmd>update<CR>

" toggle folding
" nnoremap <space> za

" fix cursor position with . and apply to all selected lines in visual mode
noremap . .`[
xnoremap <silent> . :normal .<CR>

" split windows vertically/horizontally
nnoremap <leader>x <C-w>s<C-w>j
nnoremap <leader>v <C-w>v<C-w>l

" Ex Command to cd to current file, don't run it so it can be modified
nnoremap <leader>cd :cd %:p:h

" scroll faster
nnoremap U 3<c-y>
nnoremap E 3<c-e>

" increment/decrement numbers
nnoremap + <c-a>
nnoremap - <c-x>
xnoremap + g<c-a>
xnoremap - g<c-x>

" fix common typos
" cnoremap W w
" cnoremap Q q

" Disable anoying ex mode
nnoremap Q <Nop>

" Paste from the yank buffer
nnoremap <leader>p "0p
nnoremap <leader>P "0P

" toggle spelling
nnoremap <silent> <F3> :set spell!<cr>

" Save session
nnoremap <leader>ss :mksession! $VIMDATA/sessions/
" Reload session
nnoremap <leader>sl :source $VIMDATA/sessions/

" Add shebang with #!!
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" navigate Tabs
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap ta :tab ball<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprev<CR>
nnoremap <C-t> :tabnew<CR>
nnoremap <C-d> :tabclose<CR>

"" in visual mode, use "((" etc, to enclose selection
"vnoremap (( <esc>`>a)<esc>`<i(<esc>
"vnoremap [[ <esc>`>a]<esc>`<i[<esc>
"vnoremap {{ <esc>`>a}<esc>`<i{<esc>
"vnoremap "" <esc>`>a"<esc>`<i"<esc>
"vnoremap '' <esc>`>a'<esc>`<i'<esc>

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script

"exe 'inoremap <script> <S-Insert>' paste#paste_cmd['i']
"exe 'vnoremap <script> <S-Insert>' paste#paste_cmd['v']

" CTRL-F does Find-Replace dialog instead of page forward
"noremap <C-F> :promptrepl<CR>
"vnoremap <C-F> y:promptrepl <C-R>"<CR>
"onoremap <C-F> <C-C>:promptrepl<CR>
"inoremap <C-F> <C-O>:promptrepl<CR>
"cnoremap <C-F> <C-C>:promptrepl<CR>

" +----------+
" | VIM-ZOOM |
" +----------+

" Zoom / restore windows (like Tmux)
nmap <leader>z <Plug>(zoom-toggle)
" nmap <leader>j <Plug>(zoom-toggle)

" +---------+
" | MATCHUP |
" +---------+

let g:matchup_transmute_enabled = 1

" +------------+
" | INDENTLINE |
" +------------+

" more beautiful lines (only works with UTF-8 encoded files)
let g:indentLine_char = '┊'  " alternatives: ┊ ┆ ╎ │ ⁞

" do not conceal cursor line in insert mode
let g:indentLine_concealcursor = 'n'

" do not conceal markdown/json files (indent lines still work)
" let g:markdown_syntax_conceal=0
" let g:vim_json_conceal=0

" +------------------+
" | MARKDOWN-PREVIEW |
" +------------------+

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
" file from: https://github.com/hyrious/github-markdown-css
" edited to include: style content in https://github.com/sindresorhus/github-markdown-css#usage
let g:mkdp_markdown_css = expand($XDG_CONFIG_HOME . '/css/markdown.css')

" Toggle browser preview
nmap <C-p> <Plug>MarkdownPreviewToggle

" +--------------+
" | EDITORCONFIG |
" +--------------+

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" +----------+
" | FUGITIVE |
" +----------+

" dummy func so statusline still works if fugititive isn't loaded
if !exists('*FugitiveStatusline')
    function! FugitiveStatusline()
        return ''
    endfunction
endif

" fugitive conflict resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdl :diffget //2<CR>
nnoremap gdr :diffget //3<CR>

" +-------+
" | MUNDO |
" +-------+

"let g:mundo_playback_delay=180
let g:mundo_auto_preview=1

" nnoremap <silent> <F3> :MundoToggle<CR>
nnoremap <leader>u :MundoToggle<cr>

" +---------+
" | SIGNIFY |
" +---------+

" default updatetime 4000ms is not good for async update
set updatetime=100

" +--------------+
" | VIM-SURROUND |
" +--------------+

" insert deliminator around inner word object; eg gs"
map gs ysiw

" +----------------+
" | VIM-SUBVERSIVE |
" +----------------+

" s for substitute
nmap s <plug>(SubversiveSubstitute)
xmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" +----------+
" | NERDtree |
" +----------+

" don't display informations (type ? for help and so on)
let g:NERDTreeMinimalUI = 1

"let g:NERDTreeHijackNetrw = 1
"let g:NERDTreeChDirMode = 2
"let g:NERDTreeAutoDeleteBuffer = 1
"let g:NERDTreeShowBookmarks = 0
"let g:NERDTreeCascadeOpenSingleChildDir = 1
"let g:NERDTreeCascadeSingleChildDir = 0
"let g:NERDTreeQuitOnOpen = 1

" remapping - see nerdtree.txt and search for "NERDTreeMappings"
let NERDTreeMapOpenSplit = 'x'
let NERDTreeMapPreviewSplit='gx'

let NERDTreeMapOpenVSplit = 'v'
let NERDTreeMapPreviewVSplit='gv'

" nnoremap <silent> <F2> :call general#NERDTreeToggleInCurDir()<CR>
nmap <leader>e :call general#NERDTreeToggleInCurDir()<CR>

" +----------------+
" | TMUX-NAVIGATOR |
" +----------------+

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <M-n> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-e> :TmuxNavigateDown<cr>
nnoremap <silent> <M-u> :TmuxNavigateUp<cr>
nnoremap <silent> <M-i> :TmuxNavigateRight<cr>
nnoremap <silent> <M-o> :TmuxNavigatePrevious<cr>

" +-----+
" | FZF |
" +-----+

" Location of fzf interface for vim (need both this and fzf.vim plugin)
source $FZF_VIM_DIR/fzf.vim

" History of file opened
nnoremap <leader>h :History<cr>

" Buffers opens
nnoremap <leader>b :Buffers<cr>

" Files recursively from pwd
" Everything except gitignore files
nnoremap <leader>f :Files<cr>
nnoremap <leader>F :GFiles --cached --others --exclude-standard<cr>

" Ex commands
nnoremap <leader>c :Commands<cr>
" Ex command history. <C-e> to modify the command
nnoremap <leader>: :History:<cr>

nnoremap <leader>a :Rg<space>
nnoremap <leader>A :exec "Rg ".expand("<cword>")<cr>

" ripgrep command to search in multiple files TODO: delete?
autocmd vimrc VimEnter * command! -nargs=* Rg call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Show preview window on right if >70 cols, and on top otherwise
let g:fzf_preview_window = ['right,50%,border-left,<70(up,40%)<70(up,40%,border-bottom)', 'ctrl-/']

" Use tmux float for popup if possible
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p80%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'sharp' } }
endif


" +-----------------+
" | NVIM-TREESITTER |
" +-----------------+

" if getting query error: invalid node type, see https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
" to remove additional parsers: simply rename the /lib/nvim/parser folder to e.g., /lib/nvim/parser~

lua << EOF
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    -- ensure_installed = { "bash", "bibtex", "c", "cpp", "css", "devicetree", "dockerfile", "latex", "lua", "markdown", "python", "vim", "vimdoc", "query" },
    ensure_installed = "all",

    highlight = {
        enable = true,
        -- disable = { "devicetree" },
        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>", -- set to `false` to disable one of the mappings
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },

    indent = {
        enable = true,
    },

    refactor = {

        enable = true,

        highlight_definitions = { -- highlight definition & usage of symbol under cursor
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },

        highlight_current_scope = { enable = false }, -- highlight block from current scope

        smart_rename = { -- renames symbol under cursor within current scope & file
            enable = false,
            -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
            keymaps = {
                smart_rename = "grr",
            },
        },

        navigation = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            keymaps = {
                goto_definition = "<C-.>",
                list_definitions = false,
                list_definitions_toc = false,
                goto_next_usage = "<C-n>",
                goto_previous_usage = "<C-p>",
            },
        },
    },

}

require("ibl").setup {
    -- indent = { char = "│", smart_indent_cap = false, highlight = "LineNr" },
    indent = { char = "▏", smart_indent_cap = false, highlight = "Whitespace" },
}

require("virt-column").setup {
    char = "▏",
    virtcolumn = "+1,120",
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable                     " Disable folding at startup.

" +-----+
" | Gui |
" +-----+

if exists("g:neovide")
    let g:neovide_cursor_animation_length = 0
    set linespace=2
    set guifont=Source\ Code\ Pro:h11
    " set guifont=Fira\ Code:h10
    " set guifont=JetBrains\ Mono:h10
endif


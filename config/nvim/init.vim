" File location: ~/.config/nvim/ | %USERPROFILE%/Local/nvim/
" Path to Vimfiles, set by shell under unix
if has("win32")
    " *** Setup steps on Windows:
    " * run in powershell: choco fzf
    " * create 'autoload', 'fzf_plugin', 'plugged' dirs in %USERPROFILE%/Local/nvim/
    " * save https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim to fzf_plugin
    let $VIMDATA=$USERPROFILE . '/AppData/Local/nvim'
    source $VIMDATA . '/plugins.vim'  # managed with nix in *nix
    let $FZF_VIM_DIR=$VIMDATA . '/fzf_plugin'
endif

" +----------------+
" | Global options |
" +----------------+

if (has("termguicolors"))
    set termguicolors        " truecolor support
endif
" syntax on  " superseded by treesitter?

silent! colorscheme onedark  " don't choke if colorscheme does not exist

set title mouse=a            " show title + terminal mouse support
set number relativenumber    " show relative linenumbers
set keymodel=startsel        " shift + movement starts visual mode
set scrolloff=3              " keep cursor 3 lines of edge when scrolling

" set clipboard+=unnamedplus   " use global clipboard (slows startup by 100ms if xclip or xsel are installed and 200ms with win32yank)
set autowrite                " write automatically when quitting buffer
set undofile                 " persistent undo
set fileformats=unix,dos     " default to unix fileformat on all platforms

set autoindent smartindent   " automatic indentation based on cinwords
set et sw=4 ts=4 sts=-1      " expand all tabs to spaces and set  shift/tabwidth (if no editorconfig is found)
set shiftround               " > shifts to multiples of 4 spaces, not +4
set colorcolumn=+1           " display virt-column at tw+1 (see below)

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

" set laststatus=0
" hi! link StatusLine Normal
" hi! link StatusLineNC Normal
" set statusline=%#WinSeparator#%{repeat('─',winwidth('.'))}
" set rulerformat=%59(%f\ %h%w%m%r%=%l,%c\ %P%)

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
nnoremap <space> za

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

" Copy/paste from global clipboard
noremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

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

autocmd vimrc FileType markdown
    \ :packadd markdown-preview.nvim

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
nnoremap <leader>u :packadd vim-mundo<cr>:MundoToggle<cr>

" +---------+
" | SIGNIFY |
" +---------+

" default updatetime 4000ms is not good for async update
" set updatetime=100

" +--------------+
" | VIM-SURROUND |
" +--------------+

" insert deliminator around inner word object; eg gs"
map gs ysiw

" +----------------+
" | VIM-SUBVERSIVE |
" +----------------+

" like c but replace with yank buffer
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
nmap <leader>e :packadd nerdtree<CR>:call general#NERDTreeToggleInCurDir()<CR>

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
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {},  -- let nix manage parsers

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>", -- set to `false` to disable one of the mappings
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },

    refactor = {

        enable = false,

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

    textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
  },
}

require("ibl").setup {
    indent = { char = "│", smart_indent_cap = false, highlight = "WinSeparator" },
    -- indent = { char = "▏", smart_indent_cap = false, highlight = "WinSeparator" },
}

require("virt-column").setup {
    char = "│", highlight = "WinSeparator", -- virtcolumn = "+1",
}

-- integrate ts_context_commentstring with comment.nvim
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup {
    enable_autocmd = false,
}
require('Comment').setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

require('which-key').setup()

require('gitsigns').setup{
    -- current_line_blame = true,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}

EOF

" Enable folding
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

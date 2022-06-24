" File location: ~/AppData/Local/nvim
"set nocompatible           " be iMproved, default in neovim
"filetype plugin indent on  " activate filetype detection, default in neovim

" Path to Vimfiles, set by shell under unix
if has("win32")
    let $DROPBOX='D:/Dropbox'
    let $VIMCONFIG=$USERPROFILE . '/AppData/Local/nvim'
endif

" +----------+
" | VIM-PLUG |
" +----------+

" Brief help:
" :PlugInstall      - install plugins
" :PlugUpdate       - update plugins
" :PlugClean[!]     - remove unlisted plugins (! will skip confirmation)
" :PlugUpgrade      - upgrade vim-plug itself
" :PlugStatus       - check status of plugins

call plug#begin("$VIMCONFIG/plugged")

Plug 'morhetz/gruvbox'                 " my default colorscheme
Plug 'junegunn/fzf.vim'                " fzf wrapper
Plug 'tpope/vim-commentary'            " easy commenting
Plug 'andymass/vim-matchup'            " match more stuff with %
Plug 'dhruvasagar/vim-zoom'            " tmux-like zoom for splits
Plug 'christoomey/vim-tmux-navigator'  " navigate btwn vim splits & tmux panes
Plug 'editorconfig/editorconfig-vim'   " respect editorconfig defaults in vim
Plug 'Yggdroot/indentLine'             " display indentation lines

" Git
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'mhinz/vim-signify'               " show git diff in the left gutter

" Navigate undo tree
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}

" File navigation
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}

"Plugin 'tpope/vim-surround' " surround text with paranthesis, quotes etc
"Plugin 'tpope/Vim-repeat'   " see http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
"Plugin 'w0rp/ale'           " linting platform
"Plugin 'SirVer/ultisnips'   " snippets stuff
"Plugin 'honza/vim-snippets' " snippets stuff
"Plugin 'godlygeek/tabular'  " align stuff (eg markdown tables)
"Plugin 'lervag/vimtex'      " modern latex plugin
"Plugin 'reedes/vim-wordy'   " verify quality of writting (see :Wordy)
"Plugin 'rhysd/vim-grammarous', { 'for': 'markdown' } " show grammar mistakes
"Plugin 'JamshedVesuna/vim-markdown-preview'

call plug#end()

" +----------------+
" | Global options |
" +----------------+

syntax on
silent! colorscheme gruvbox  " don't choke if colorscheme does not exist
"language en                  " ignore system language

set mouse=a                  " terminal mouse support
set title number             " show title and linenumber
set relativenumber           " show relative linenumbers
set colorcolumn=+1           " color column at textwidth+1
set scrolloff=3              " keep cursor 3 lines of edge when scrolling
set textwidth=88             " default textwidth of 80 columns
set diffopt+=vertical        " use vertical splits for diff

set autoindent smartindent   " automatic indentation based on cinwords
set et sw=4 sts=4 ts=4       " expand all tabs to spaces and set tabwidth
set ignorecase smartcase     " search ignores cases unless uppercase
set completeopt+=longest     " completion insert longest common matched text

set autowrite                " write automatically when quitting buffer
set undofile                 " persistent undo
set fileformats=unix,dos     " default to unix fileformat on all platforms

set keymodel=startsel        " shift + movement starts visual mode
"set clipboard+=unnamedplus   " use global clipboard
"set spelllang=en_us          " make English default spelling language

" Formatting symbols
set list
set listchars+=eol:⏎         " end-of-line
set listchars+=tab:▸\        " tab
set listchars+=trail:·       " trailing spaces, leading spaces are blank
set listchars+=extends:>     " last col of long lines when line wrap is off
set listchars+=precedes:<    " first col of long lines when line wrap is off
set listchars+=nbsp:%        " non-breakable space character

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

" +------------+
" | statusline |
" +------------+

set laststatus=2
set statusline=%<                        " truncate here if needed
set statusline+=%f\                      " file + path relative to current dir
set statusline+=%h%w%m%r                 " help, preview, modified, readonly
set statusline+=%{FugitiveStatusline()}  " git status
set statusline+=%=                       " hfill
set statusline+=%{&fenc?&fenc:&enc}\     " file encoding
set statusline+=%-11.([%{&ff}]%)\        " [file format], minimum width = 11
set statusline+=%-12.(%l/%L%)\           " line/total, minimum width = 12
set statusline+=%P                       " top/bottom

" +-----------------+
" | General mapping |
" +-----------------+

" Configure leader key
let mapleader = ","
let maplocalleader = ","

" Indent without killing the selection in VISUAL mode
vmap < <gv
vmap > >gv

" toggle between absolute -> relative line number
nnoremap <leader>n <Cmd>set relativenumber!<CR>

" escape to normal mode and write unsaved changes with <S-CR>, won't work in VT
"inoremap <s-cr> <esc>
"nnoremap <silent><s-cr> <Cmd>update<CR>

" turn off highlighting of search results
nnoremap <silent> <esc> <Cmd>noh<cr>
"nnoremap <silent> <leader><space> <Cmd>noh<cr>

" toggle folding
nnoremap <space> za

" fix cursor position with . and apply to all selected lines in visual mode
noremap . .`[
vnoremap <silent> . :normal .<CR>

" split windows vertically/horizontally
nnoremap <leader>x <C-w>s<C-w>j
nnoremap <leader>v <C-w>v<C-w>l

" Ex Command to cd to current file, don't run it so it can be modified
nnoremap <leader>cd :cd %:p:h

" scroll faster
noremap U 3<c-y>
noremap E 3<c-e>

" increment/decrement numbers
nnoremap + <c-a>
nnoremap - <c-x>

" fix common typos
cnoremap W w
cnoremap Q q

" Disable anoying ex mode
nnoremap Q <Nop>

" Paste from the yank buffer
nnoremap <leader>p "0p
nnoremap <leader>P "0P

" use F1 to escape to normal, count words in visual, quit help, and pastetoggle
inoremap <F1> <Esc>
" TODO: why is output cleared when using vmap?
vnoremap <F1> g<C-g>
nnoremap <silent><F1> :call MapF1()<CR>

function! MapF1()
    if &buftype == "help"
        exec 'quit'
    else
        exec 'set invpaste'
        exec 'set paste?'
    endif
endfunction

" toggle spelling
nnoremap <silent> <F4> :set spell!<cr>

" Save session
nnoremap <leader>ss :mksession! $VIMCONFIG/sessions/
" Reload session
nnoremap <leader>sl :source $VIMCONFIG/sessions/

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

" +--------+
" | Macros |
" +--------+

" Convert file endings from dos to unix
function! Dos2Unix()
    exec 'e ++ff=dos'
    exec 'w ++ff=unix'
endfunction

" +----------+
" | VIM-ZOOM |
" +----------+

" Zoom / restore windows (like Tmux)
nmap <leader>z <Plug>(zoom-toggle)
nmap <leader>j <Plug>(zoom-toggle)

" +---------+
" | MATCHUP |
" +---------+

let g:matchup_transmute_enabled = 1

" +------------+
" | INDENTLINE |
" +------------+

" use more beautiful lines (only works with UTF-8 encoded files)
let g:indentLine_char = '┊'  " alternatives: ┊ ┆ ╎ │ ⁞

" +--------------+
" | EDITORCONFIG |
" +--------------+

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" +------------+
" | FUGITIVE |
" +------------+

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

nnoremap <silent> <F3> :MundoToggle<CR>
nnoremap <leader>U :MundoToggle<cr>

" +---------+
" | SIGNIFY |
" +---------+

" default updatetime 4000ms is not good for async update
set updatetime=100

" +----------+
" | NERDtree |
" +----------+

function! NERDTreeToggleInCurDir()
    " If NERDTree is open in the current buffer
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exec ":NERDTreeClose"
    else
        if (expand("%:t") != '')
            exec ":NERDTreeFind"
        else
            exec ":NERDTreeToggle"
        endif
    endif
endfunction

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

nnoremap <silent> <F2> :call NERDTreeToggleInCurDir()<CR>
nmap <leader>e :call NERDTreeToggleInCurDir()<CR>

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
source $FZF_PLUG_DIR/fzf.vim

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

" Customize fzf colors to match the current color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Search'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Visual'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'StatusLineNC'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


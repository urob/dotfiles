" File location: ~/AppData/Local/nvim
set nocompatible    " be iMproved, required
filetype off        " required

" Path to Vimfiles, set by shell under unix
if has("win32")
    let $DROPBOX='D:/Dropbox'
    let $VIMCONFIG=$USERPROFILE . '/AppData/Local/nvim'
endif
let $VIMFILES=$DROPBOX . '/home/nvim'


" +--------+
" | Vundle |
" +--------+

" Brief help:
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Set runtime path to include Vundle and initialize
set rtp+=$VIMFILES/bundle/Vundle.vim/
call vundle#begin('$VIMFILES/bundle/')

" Let Vundle manage itself, required
Plugin 'VundleVim/Vundle.vim'

" Vundle plugins
Plugin 'tomasr/molokai'
Plugin 'morhetz/gruvbox'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'dhruvasagar/vim-zoom'  " zoom in vim splits

"Plugin 'tpope/vim-surround' " surrounding text objects with paranthesis, quotes, html tags...
"Plugin 'tpope/Vim-repeat' " the . command can repeat whatever you want! See http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/

"Plugin 'ctrlpvim/ctrlp.vim' " fuzzy file buffer tag etc finder
"Plugin 'w0rp/ale' " Linting platform

" Snippets
"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets' " snippets

" Undo tree
"Plugin 'simnalamburt/vim-mundo' " Undo tree display

" Git
"Plugin 'tpope/vim-fugitive' "wrapper for git
"Plugin 'mhinz/vim-signify' "  display git diff in the left gutter
"Plugin 'junegunn/gv.vim' " Display commits for project / file

" Writing
"Plugin 'godlygeek/tabular' " Align stuff (useful for markdown tables for example)
"Plugin 'lervag/vimtex' " latex
"Plugin 'reedes/vim-wordy' " Verify quality of writting (see :Wordy)
"Plugin 'rhysd/vim-grammarous', { 'for': 'markdown' } " Show grammar mistakes
"Plugin 'JamshedVesuna/vim-markdown-preview'

" All plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" +------------------+
" | Global variables |
" +------------------+

" BufExplorer
let g:bufExplorerShowRelativePath=1


" +--------------+
" | Set  options |
" +--------------+

syntax on
colorscheme gruvbox         " choose a colorscheme
"language en                 " ignore system language

set mouse=a                 " terminal mouse support
set title number            " show title and linenumber
set colorcolumn=+1          " color column at textwidth+1
set scrolloff=3             " keep cursor 3 lines of edge when scrolling
set textwidth=79            " default textwidth of 79 columns

" Formatting symbols
set list
set listchars+=eol:⏎        " end-of-line
set listchars+=tab:▸\       " tab
set listchars+=trail:·      " trailing spaces, leading spaces are blank
set listchars+=extends:>    " last col of long lines when line wrap is off
set listchars+=precedes:<   " first col of long lines when line wrap is off
set listchars+=nbsp:%       " non-breakable space character

set autoindent smartindent  " Automatic indentation based on cinwords
set et sw=4 sts=4 ts=4      " Expand all tabs to spaces and set tabwidth
set ignorecase smartcase    " Search ignores cases unless uppercase
set completeopt+=longest    " completion insert longest common matched text

set autowrite               " Write automatically when quitting buffer
set undofile                " Persistent undo
set fileformats=unix,dos    " always use unix fileformats as default

set keymodel=startsel       " shift-arrows starts visual mode
set clipboard+=unnamed      " use global clipboard
"set spelllang=en_us         " make English default spelling language


" +---------+
" | autocmd |
" +---------+

au FileType markdown setlocal spell spelllang=en_us
au FileType gitcommit setlocal spell spelllang=en_us

" Return to last edit position when opening files
au BufReadPost * 
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \       exe "normal! g`\"" |
            \ endif

" Trigger 'autoread' when files change on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() != 'c' | checktime | endif

" Notification after file change
autocmd FileChangedShellPost *
            \ echohl WarningMsg |
            \ echo "File changed on disk. Buffer reloaded." | echohl None


" +------------+
" | statusline |
" +------------+

set laststatus=2
set statusline=%<                        " truncate here if needed
set statusline+=%f\                      " file + path relative to current dir
set statusline+=%h%w%m%r                 " help, preview, modified, readonly
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

" indent without killing the selection in VISUAL mode
vmap < <gv
vmap > >gv

" toggle between absolute -> relative line number
nnoremap <C-n> :set relativenumber! <CR>

" escape to normal mode and write unsaved changes with <S-CR>
"inoremap <s-cr> <esc>
"nnoremap <silent><s-cr> :update<CR>

" turn off highlighting of search results
" nnoremap <silent> <leader><space> :noh<cr>
nnoremap <silent> <esc> <Cmd>noh<cr>

" toggle folding
nnoremap <space> za

" fix cursor position with . and apply to all selected lines in visual mode
noremap . .`[
vnoremap <silent> . :normal .<CR>

" split windows vertically/horizontally
nnoremap <leader>h <C-w>s<C-w>j
nnoremap <leader>v <C-w>v<C-w>l

" navigate around split using <leader> + arrow
nnoremap <leader><Up> <C-w>k
nnoremap <leader><Down> <C-w>j
nnoremap <leader><Left> <C-w>h
nnoremap <leader><Right> <C-w>l

" Zoom / restore windows (like Tmux), requires vim-zoom plugin
nmap <leader>z <Plug>(zoom-toggle)

" Ex Command to cd to current file, don't run it so it can be modified
nnoremap <leader>cd :cd %:p:h

" scroll down faster
"noremap J 2<c-e>
"noremap K 3<c-y>

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
" TODO: why does the shortcut not pause after display?
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

nnoremap <silent> <F2> :BufExplorer<CR>
"nnoremap <silent> <F3> :GundoToggle<CR>
"nnoremap <silent> <F4> :TagbarToggle<CR>

" toggle spelling
nnoremap <silent> <F5> :set spell!<cr>

" <F5>-<F8> reserved for filetype mappings

" Save session
nnoremap <leader>ss :mksession! $XDG_STATE_HOME/nvim/sessions/
" Reload session
nnoremap <leader>sl :source $XDG_STATE_HOME/nvim/sessions/

" Source sets of macros
"nnoremap <leader>ml :source $VIMCONFIG/macros/

"nmap <F10> :wa<Bar>exe "mksession! " . v:this_session<CR>:so $VIMFILES/sessions/
"nnoremap <F10> :wa<Bar>exe "mksession! " . v:this_session<CR>
"nnoremap <silent><F12> :call MySpellLang()<CR>

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

"" automatically close "(" and "["
"inoremap ( ()<ESC>i
"inoremap [ []<ESC>i
""inoremap { {}<ESC>i
"
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
    exe 'e ++ff=dos'
    exe 'w ++ff=unix'
endfunction


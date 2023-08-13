vim.g.mapleader = ','

local set = vim.opt
set.tabstop = 2
set.expandtab = true
set.wildignore = {'*/cache/*', '*/tmp/*'}
set.listchars = {eol = '↲', tab = '▸ ', trail = '·'}

-- append or remove items
set.errorformat:append('%f|%l col %c|%m')

-- set environment variables
vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'



local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})
Plug('junegunn/goyo.vim', {['for'] = 'markdown'})


vim.call('plug#end')


-- source stuff written in viml
vim.cmd 'source ~/.config/nvim/keymaps.vim'

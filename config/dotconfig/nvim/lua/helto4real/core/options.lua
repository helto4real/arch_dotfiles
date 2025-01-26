local opt = vim.opt -- for easier to read

-- leader  have to be set before plugins and all other configs
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- helps perfomance on windows with my anti-virus software
vim.g.nofsync = true
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Don't show the mode, since it's already in status line
opt.showmode = false

-- Enable break indent
opt.breakindent = true

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = false
-- opt.listchars = { trail = '·', nbsp = '␣' }
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'
-- higlight matches while searching
opt.incsearch = true

-- let's get smart indenting
opt.smartindent = true
-- No annoying backups
opt.backup = false
-- no wrapping helps for code
opt.wrap = false

-- indention to 4 characters
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- expand on tab
opt.expandtab = true

-- do not highligt previous searches
opt.hlsearch = true
-- do ignore case search when search
opt.ignorecase = true
-- case sensitive if a case character is part of search
opt.smartcase = true

opt.showtabline = 1 -- always show tabs
vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- shows a line where the cursor is
opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

opt.pumheight = 10 -- pop up menu height
opt.pumblend = 10
-- apperance

-- use terminal gui colors
opt.termguicolors = true
-- always use dark
opt.background = "dark"
opt.signcolumn = "yes"

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- enable conceallevel for markdown
vim.opt.conceallevel = 1

opt.backspace = "indent,eol,start"

-- use line numbers
opt.nu = true
-- and use relateive line numbers
opt.relativenumber = true

-- enable spell checking
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

vim.cmd([[au BufNewFile,BufRead *.v set filetype=v]])

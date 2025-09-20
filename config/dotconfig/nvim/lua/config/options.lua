-- Options are automatically loaded before lazy.nvim startup Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua Add any additional options here

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.snacks_animate = false
-- Don't show the mode, since it's already in status line
local opt = vim.opt -- for easier to read

-- higlight matches while searching
opt.incsearch = true

-- No annoying backups
opt.backup = false
-- no wrapping helps for code
opt.wrap = false

-- higlight matches while searching
opt.incsearch = true
-- do not highligt previous searches
opt.hlsearch = true
-- do ignore case search when search
opt.ignorecase = true
-- case sensitive if a case character is part of search
opt.smartcase = true
-- let's get smart indenting
opt.smartindent = true

-- enable conceallevel for markdown
opt.conceallevel = 1
opt.spell = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap --short

local function map(mode, lhs, rhs, desc, opts)
  local options = { noremap = true, silent = true, desc = desc }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

keymap.set("i", "jj", "<ESC>")
-- Select all
keymap.set("n", "<C-a>", "ggVG")
-- remove highlight for search
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- window splitting
map("n", "<leader>wv", "<C-w>s", "Split (V)ertically")
map("n", "<leader>ws", "<C-w>v", "(S)plit")
map("n", "<leader>we", "<C-w>=", "(E)qual width")
map("n", "<leader>wx", ":close<CR>", "Close (X)")

-- smart moving and stuff
map("v", "J", ":m '>+1<CR>gv=gv", "Move line down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move line up")

map("n", "<C-d>", "<C-d>zzj", "Go half page down")
map("n", "<C-u>", "<C-u>zz", "Go half page up")
map("n", "n", "nzzzv", "Next search down")
map("n", "N", "Nzzzv", "Next search up")

map("n", "<leader>ule", "<cmd>setlocal spell spelllang=en_us<CR>", "Spell check - English")
map("n", "<leader>uls", "<cmd>setlocal spell spelllang=sv<CR>", "Spell check - Swedish")
map("n", "<leader>uld", "<cmd>setlocal nospell<CR>", "Disable spell checking")

map("n", "<leader>fy", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, "Yank full file path")

vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gri")

vim.keymap.set({ "n", "o", "x" }, "<c-g>", function()
  require("flash").treesitter({
    actions = {
      ["<c-g>"] = "next",
      ["<BS>"] = "prev",
    },
  })
end, { desc = "Treesitter Incremental Selection" })

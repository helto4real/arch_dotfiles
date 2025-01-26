vim.cmd('source ~/.config/nvim/lua/helto4real/core/keymaps.vim')

local keymap = vim.keymap --short

local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true, desc = desc }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Do not copy single character
keymap.set("n", "x", '"_x')
keymap.set("n", "<C-a>", "ggVG")

-- remove highlight for search
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- window splitting
map('n', '<leader>wv', '<C-w>v', 'Split [W]indow [V]ertically')
map("n", "<leader>wh", "<C-w>s", "Split [W]indow horizontally")
map("n", "<leader>ws", "<C-w>s", "Split [W]indow horizontally")
map("n", "<leader>we", "<C-w>=", "[W]indow [=]equal width")
map("n", "<leader>wx", ":close<CR>", "[W]indow close")

map("n", "<leader>wm", ":MaximizerToggle<CR>", "[W]indow [M]aximize toggle")

-- move through windows
map("n", "<leader>wl", "<C-w><C-l>", "Move cursor to [W]indow Left");
map("n", "<leader>wh", "<C-w><C-h>", "Move cursor to [W]indow Right");
map("n", "<leader>wk", "<C-w><C-k>", "Move cursor to [W]indow up");
map("n", "<leader>wj", "<C-w><C-j>", "Move cursor to [W]indow right");

-- window tabbing
map("n", "<leader>tn", ":tabnew<CR>", "New [T]ab")     -- open new tab
map("n", "<leader>tx", ":tabclose<CR>", "Close [T]ab") -- close current tab
map("n", "<leader>tl", ":tabn<CR>", "Next [T]ab")      -- goto next tab
map("n", "<leader>th", ":tabp<CR>", "Previous [T]ab")  -- goto previous tab

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
map('n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
map('n', '<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')

-- smart moving and stuff
map("v", "J", ":m '>+1<CR>gv=gv", "Move line down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move line up")
map("n", "M", "mzJ`z", "Merge lijkkkkkne")
map("n", "<C-d>", "<C-d>zzj", "Go half page down")
map("n", "<C-u>", "<C-u>zz", "Go half page up")
map("n", "n", "nzzzv", "Next search down")
map("n", "N", "Nzzzv", "Next search up")

map({ "n", "o", "x" }, "<s-h>", "^") -- Move to the end of the line
map({ "n", "o", "x" }, "<s-l>", "g_") -- Move to the start of first character of the line

-- Keep copy buffer intact in muliple paste
map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
-- makes ctr+c work like escape
map("i", "<C-c>", "<Esc>")

map("n", "Q", "<nop>")

map("n", "<leader>le", "<cmd>setlocal spell spelllang=en_us<CR>", "Spell check - [E]nglish")
map("n", "<leader>ls", "<cmd>setlocal spell spelllang=sv<CR>", "Spell check - [S]wedish")
map("n", "<leader>ld", "<cmd>setlocal nospell<CR>", "[D]isable spell checking")

-- I know I miss those vscode c+s save thing
map("n", "<C-s>", "<cmd>w<CR>")
map("i", "<C-s>", "<Esc><cmd>w<CR>")

map('t', '<esc>', [[<C-\><C-n>]])
map('t', 'jk', [[<C-\><C-n>]])

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "A-j", "<cmd>cnext<CR>zz", "Next quickfix")
map("n", "A-k", "<cmd>cprev<CR>zz", "Previous quickfix")

local keymap = vim.keymap --short

local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true, desc = desc }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

keymap.set("i", "jj", '<ESC>')

-- Do not copy single character
keymap.set("n", "x", '"_x')
-- Select all
keymap.set("n", "<C-a>", "ggVG")

-- remove highlight for search
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- window splitting
map('n', '<leader>wv', "<C-w>s", 'Split (V)ertically')
map("n", "<leader>ws", "<C-w>v", "(S)plit")
map("n", "<leader>we", "<C-w>=", "(E)qual width")
map("n", "<leader>wx", ":close<CR>", "Close (X)")

-- window tabbing
map("n", "<leader>tn", ":tabnew<CR>", "(N)ew")     -- open new tab
map("n", "<leader>tx", ":tabclose<CR>", "Close (X)") -- close current tab
map("n", "<leader>tj", ":tabn<CR>", "Next (J)")      -- goto next tab
map("n", "<leader>tk", ":tabp<CR>", "Previous (K)")  -- goto previous tab

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, 'Diagnostic message')
map('n', ']d', vim.diagnostic.goto_next, 'Diagnostic message')
map('n', '<leader>ee', vim.diagnostic.open_float, 'Diagnostic m(e)ssage')
map('n', '<leader>ew', vim.diagnostic.setloclist, 'Diagnostics (W)indow')

-- smart moving and stuff
map("v", "J", ":m '>+1<CR>gv=gv", "Move line down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move line up")

-- Merge current line with next line
map("n", "M", "mzJ`z", "Merge current line with next line")

map("n", "<C-d>", "<C-d>zzj", "Go half page down")
map("n", "<C-u>", "<C-u>zz", "Go half page up")
map("n", "n", "nzzzv", "Next search down")
map("n", "N", "Nzzzv", "Next search up")

-- Buffers
map({ "n" }, "<s-j>", "<cmd>bnext<CR>", "Next buffer")
map({ "n" }, "<s-k>", "<cmd>bprev<CR>", "Previous buffer")

-- Keep copy buffer intact in muliple paste
map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map("n", "Q", "<nop>")

-- Spell check keymaps
map("n", "<leader>le", "<cmd>setlocal spell spelllang=en_us<CR>", "Spell check - [E]nglish")
map("n", "<leader>ls", "<cmd>setlocal spell spelllang=sv<CR>", "Spell check - [S]wedish")
map("n", "<leader>ld", "<cmd>setlocal nospell<CR>", "[D]isable spell checking")

-- I know I miss those vscode c+s save thing
map("n", "<C-s>", "<cmd>w<CR>")
map("i", "<C-s>", "<Esc><cmd>w<CR>")

map('t', '<esc>', [[<C-\><C-n>]])

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "A-j", "<cmd>cnext<CR>zz", "Next quickfix")
map("n", "A-k", "<cmd>cprev<CR>zz", "Previous quickfix")

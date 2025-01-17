vim.cmd('source ~/.config/nvim/lua/helto4real/plugins/dev/copilot.vim')
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestions = { enabled = false },
            panel = { enables = false },
        })
    end,
}

-- return {
--     'zbirenbaum/copilot.lua',
--     event = "VeryLazy",
--     opts = {
--         suggestions = { enabled = false },
--         panel = { enables = false },
--     },
--     keys = {
--         {
--             mode = "i",
--             "<c-s-h>",
--             'copilot#Accept("\\<CR>")',
--             expr = true,
--             replace_keycodes = false,
--             desc = "Accept",
--         },
--         {
--             mode = "i",
--             "<c-s-ö>",
--             'copilot#Dismiss()',
--             expr = true,
--             replace_keycodes = false,
--             desc = "Dismiss",
--         },
--
--     },




-- imap <silent><script><expr> <SC-H> copilot#Accept("\<CR>")
-- imap <silent><script><expr> <SC-Ö> copilot#Dismiss()
-- imap <silent><script><expr> <SC-J> copilot#Next()
-- imap <silent><script><expr> <SC-K> copilot#Previous()

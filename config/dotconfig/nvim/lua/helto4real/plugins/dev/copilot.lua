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


return {
    event = "VeryLazy",
    'folke/zen-mode.nvim',
    keys = {
        {
            "<leader>zz",
            mode = { "n" },
            function()
                require("zen-mode").setup {
                    window = {
                        width = 150,
                        options = {}
                    },
                }
                require("zen-mode").toggle()
                vim.wo.wrap = false
                vim.wo.number = true
                vim.wo.rnu = true
            end,
            { desc = "Zen mode normal" }
        },
        {
            "<leader>zZ",
            mode = { "n" },
            function()
                require("zen-mode").setup {
                    window = {
                        width = 150,
                        options = {}
                    },
                }
                require("zen-mode").toggle()
                vim.wo.wrap = false
                vim.wo.number = false
                vim.wo.rnu = false
                vim.opt.colorcolumn = "0"
            end,
            { desc = "Zem mode focus" }
        },

    },

}

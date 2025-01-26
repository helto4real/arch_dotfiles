return {
    "folke/trouble.nvim",
    --dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
            {
                mode = { 'n' },
                '<Leader>co',
                '<cmd>Trouble<cr>',
                desc = 'Tr[o]uble',
            },
    },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}

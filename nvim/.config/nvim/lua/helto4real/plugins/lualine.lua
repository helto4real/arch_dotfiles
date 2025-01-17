return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = {"InsertEnter", "CmdLineEnter"},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = true,
            theme = 'tokyonight',
            component_separators = '|',
            section_separators = '',
        },
    },
}

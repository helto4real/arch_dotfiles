return {
    -- Tokyo night theme
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        -- your config
        require('tokyonight').setup({
            style = "night",
            transparent = false,
            on_colors = function(colors)
                colors.bg = "#191a25"
            end,
            on_highlights = function (hl, c)
               hl.CursorLine = {
                    bg = "#1f202e",
                }
               hl.CmpNormal = {
                    bg = "#292b3d",
                }
            end,
        })
        vim.cmd([[colorscheme tokyonight]])
    end,
}

-- return {
--     'mg979/vim-visual-multi',
-- }
-- lazy.nvim:
return {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>mm',
                '<cmd>MCstart<cr>',
                desc = '[M]ulti cursor',
            },
        },
}

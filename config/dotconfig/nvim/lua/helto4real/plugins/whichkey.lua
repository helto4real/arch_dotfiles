return {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 0,
        icons = {
            -- set icon mappings to true if you have a Nerd Font
            mappings = vim.g.have_nerd_font,
            -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
            -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
            keys = vim.g.have_nerd_font and {} or {
                Up = '<Up> ',
                Down = '<Down> ',
                Left = '<Left> ',
                Right = '<Right> ',
                C = '<C-…> ',
                M = '<M-…> ',
                D = '<D-…> ',
                S = '<S-…> ',
                CR = '<CR> ',
                Esc = '<Esc> ',
                ScrollWheelDown = '<ScrollWheelDown> ',
                ScrollWheelUp = '<ScrollWheelUp> ',
                NL = '<NL> ',
                BS = '<BS> ',
                Space = '<Space> ',
                Tab = '<Tab> ',
                F1 = '<F1>',
                F2 = '<F2>',
                F3 = '<F3>',
                F4 = '<F4>',
                F5 = '<F5>',
                F6 = '<F6>',
                F7 = '<F7>',
                F8 = '<F8>',
                F9 = '<F9>',
                F10 = '<F10>',
                F11 = '<F11>',
                F12 = '<F12>',
            },
        },

        -- Document existing key chains
        spec = {
            { '<leader>c', group = '[C]ode',     mode = { 'n', 'x' } },
            { '<leader>ct', group = '[T]est',     mode = { 'n', 'x' } },
            { '<leader>cgh', group = '[G]itub',     mode = { 'n', 'x' } },
            { '<leader>cc', group = '[C]opilot',     mode = { 'n', 'x' } },
            { '<leader>cghp', group = '[P]R',     mode = { 'n', 'x' } },
            { '<leader>cghc', group = '[C]omment',     mode = { 'n', 'x' } },
            { '<leader>cghl', group = '[L]abel',     mode = { 'n', 'x' } },
            { '<leader>cghpr', group = '[R]eview',     mode = { 'n', 'x' } },
            { '<leader>cghr', group = '[R]epo',     mode = { 'n', 'x' } },
            { '<leader>cghi', group = '[I]ssue',     mode = { 'n', 'x' } },
            { '<leader>cg', group = '[G]it',     mode = { 'n', 'x' } },
            { '<leader>cd', group = '[D]otnet',     mode = { 'n', 'x' } },
            { '<leader>g', group = '[G]oto' },
            { '<leader>f', group = '[F]ind' },
            { '<leader>m', group = '[M]arkdown/[M]ulti cursor' },
            { '<leader>fs', group = '[S]ymols' },
            { '<leader>fd', group = '[D]iagnostics' },
            { '<leader>z', group = '[Z]en mode' },
            { '<leader>t', group = '[T]ab' },
            { '<leader>w', group = '[W]indow' },
            { '<leader>h', group = '[H]arpoon' },
            { '<leader>l', group = '[L]anguage' },
            { '<leader>o', group = '[O]bsidian' },
            { '<leader>ol', group = '[L]ink' },
        },
    },
}

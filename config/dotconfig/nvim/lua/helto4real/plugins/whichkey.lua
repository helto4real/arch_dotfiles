return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 300,
        icons = {},

        -- Document existing key chains
        spec = {
            { '<leader>c',     group = '(C)ode',                   mode = { 'n', 'x' } },
            { '<leader>ct',    group = '(T)est',                   mode = { 'n', 'x' } },
            { '<leader>cgh',   group = '(G)itub',                  mode = { 'n', 'x' } },
            { '<leader>cc',    group = '(C)opilot',                mode = { 'n', 'x' } },
            { '<leader>cghp',  group = '(P)R',                     mode = { 'n', 'x' } },
            { '<leader>cghc',  group = '(C)omment',                mode = { 'n', 'x' } },
            { '<leader>cghl',  group = '(L)abel',                  mode = { 'n', 'x' } },
            { '<leader>cghpr', group = '(R)eview',                 mode = { 'n', 'x' } },
            { '<leader>cghr',  group = '(R)epo',                   mode = { 'n', 'x' } },
            { '<leader>cghi',  group = '(I)ssue',                  mode = { 'n', 'x' } },
            { '<leader>cg',    group = '(G)it',                    mode = { 'n', 'x' } },
            { '<leader>cd',    group = '(D)otnet',                 mode = { 'n', 'x' } },
            { '<leader>g',     group = '(G)oto' },
            { '<leader>ft',    group = '(T)asks' },
            { '<leader>fg',    group = '(G)it' },
            { '<leader>f',     group = '(F)ind' },
            { '<leader>w',     group = '(W)indow' },
            { '<leader>e',     group = 'Diagnistics(E)' },
            { '<leader>m',     group = '(M)arkdown/[M]ulti cursor' },
            { '<leader>fs',    group = '(S)ymols' },
            { '<leader>fd',    group = '(D)iagnostics' },
            { '<leader>z',     group = '(Z)en mode' },
            { '<leader>t',     group = '(T)ab' },
            { '<leader>w',     group = '(W)indow' },
            { '<leader>l',     group = '(L)anguage' },
            { '<leader>o',     group = '(O)pen code' },
            { '<leader>ol',    group = '(L)ink' },
            { '[',             group = 'Previous ([)' },
            { ']',             group = 'Next (])' },
        },
    },
}

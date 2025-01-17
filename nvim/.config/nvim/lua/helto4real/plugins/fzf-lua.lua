return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local fzf_lua = require('fzf-lua')
        local actions = require('fzf-lua.actions')

        fzf_lua.setup({
            keymap  = {
                builtin = {
                    ["<F1>"]     = "toggle-help",
                    ["<F2>"]     = "toggle-fullscreen",
                    -- Only valid with the 'builtin' previewer
                    ["<F3>"]     = "toggle-preview-wrap",
                    ["<F4>"]     = "toggle-preview",
                    ["<F5>"]     = "toggle-preview-ccw",
                    ["<F6>"]     = "toggle-preview-cw",
                    ["<C-d>"]    = "preview-page-down",
                    ["<C-u>"]    = "preview-page-up",
                    ["<S-left>"] = "preview-page-reset",
                },
                fzf = {
                    ["ctrl-z"] = "abort",
                    ["ctrl-f"] = "half-page-down",
                    ["ctrl-b"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["alt-a"]  = "toggle-all",
                    -- Only valid with fzf previewers (bat/cat/git/etc)
                    ["f3"]     = "toggle-preview-wrap",
                    ["f4"]     = "toggle-preview",
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            actions = {
                files = {
                    ["enter"]  = actions.file_edit_or_qf,
                    ["ctrl-y"] = actions.file_edit_or_qf,
                    ["ctrl-s"] = actions.file_vsplit,
                    ["ctrl-v"] = actions.file_split,
                    ["ctrl-t"] = actions.file_tabedit,
                    ["alt-q"]  = actions.file_sel_to_qf,
                    ["alt-l"]  = actions.file_sel_to_ll,
                },
            },
        })
    end,
    keys = {
        {
            "<leader>ff",
            function() require('fzf-lua').files({}) end,
            desc = "(F)ind (f)iles",
        },
        {
            "<leader>fr",
            function() require('fzf-lua').live_grep_native({}) end,
            desc = "(F)ind with (G)rep",
        },
        {
            "<leader><space>",
            function() require('fzf-lua').buffers({}) end,
            desc = "(F)ind open (space)Buffers",
        },
        {
            "<leader>fg",
            function() require('fzf-lua').git_files({}) end,
            desc = "(F)ind with (G)it files",
        },
        {
            "<leader>fdd",
            function() require('fzf-lua').lsp_document_diagnostics({}) end,
            desc = "(F)ind (D)iagnistics (D)ocument",
        },
        {
            "<leader>fdw",
            function() require('fzf-lua').lsp_workspace_diagnostics({}) end,
            desc = "(F)ind (D)iagnistic (W)orkspace",
        },
        {
            "<leader>fq",
            function() require('fzf-lua').quickfix({}) end,
            desc = "(F)ind in (Q)uickfix list",
        },
        {
            "<leader>fh",
            function() require('fzf-lua').helptags({}) end,
            desc = "(F)ind in (H)elp tags",
        },
        {
            "<leader>fk",
            function() require('fzf-lua').keymaps({}) end,
            desc = "(F)ind (K)eymaps",
        },
        {
            "<leader>/",
            function() require('fzf-lua').lgrep_curbuf({}) end,
            desc = "Find fuzzy in current buffer",
        },
    },
}

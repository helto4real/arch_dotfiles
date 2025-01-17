return
{
    {
        'saghen/blink.compat',
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = '*',
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            'giuxtaposition/blink-cmp-copilot',
        },
        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust build = 'cargo build --release', If you use nix, you can build from source using latest nightly rust with: build = 'nix run .#build-plugin',

        opts = {

            appearance = {
                -- -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- -- Useful for when your theme doesn't support blink.cmp
                -- -- will be removed in a future release
                -- use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
                providers = {
                    copilot = {
                        name = 'copilot',
                        module = 'blink-cmp-copilot',
                        score_offset = 100,
                        async = true,
                    },
                },
            },
            keymap = {
                -- set to 'none' to disable the 'default' preset
                preset = 'default',
                ['<c-k>'] = { 'select_prev', 'fallback' },
                ['<c-j>'] = { 'select_next', 'fallback' },
                ['<c-y>'] = { 'select_and_accept' },
                ['<c-n>'] = { 'show', 'show_documentation', 'hide_documentation' },
            },

            completion = {
                -- Show documentation when selecting a completion item
                documentation = { auto_show = true, auto_show_delay_ms = 500 },

                -- Display a preview of the selected item on the current line
                ghost_text = { enabled = true },

            },
            -- keymap = { preset = 'default' },
            -- keymap = {
            --     -- set to 'none' to disable the 'default' preset
            --     preset = 'none',
            --
            --     ['<c-k>'] = { 'select_prev', 'fallback' },
            --     ['<c-j>'] = { 'select_next', 'fallback' },
            --     ['<c-y>'] = { 'select_and_accept' },
            --     ['<c-n>'] = { 'show', 'show_documentation', 'hide_documentation' },




            -- disable a keymap from the preset
            -- ['<C-e>'] = {},

            -- show with a list of providers
            -- ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
            --
            -- -- control whether the next command will be run when using a function
            -- ['<C-n>'] = {
            --     function(cmp)
            --         if some_condition then return end -- runs the next command
            --         return true -- doesn't run the next command
            --     end,
            --     'select_next'
            -- },
            -- },


            -- optionally disable cmdline completions
            -- cmdline = {},

            -- experimental signature help support
            -- signature = { enabled = true }

        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" }
    }
}

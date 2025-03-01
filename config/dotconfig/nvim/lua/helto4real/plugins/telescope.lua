return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
        local actions = require("telescope.actions")
        require('telescope').setup({
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
            -- defaults = {
            --     mappings = {
            --         i = {
            --             ['<C-u>'] = false,
            --             ['<C-d>'] = false,
            --             ['<C-j>'] = actions.move_selection_next,
            --             ['<C-k>'] = actions.move_selection_previous,
            --             ['<C-q>'] = actions.smart_send_to_qflist,
            --         },
            --     },
            -- },
            find_files = {

                hidden = true

            }
        })
        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- telescope maps
        -- See `:help telescope.builtin`
        -- local keymap = vim.keymap
        -- keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
        -- keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
        -- keymap.set('n', '<leader>/', function()
        --     -- You can pass additional configuration to telescope to change theme, layout, etc.
        --     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        --         winblend = 10,
        --         previewer = false,
        --     })
        -- end, { desc = '[/] Fuzzily search in current buffer' })

        -- keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = 'Find [G]it files' })
        -- keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
        -- keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
        -- keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
        -- keymap.set('n', '<leader>fr', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
        -- keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
        -- keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymap' })
    end,
}

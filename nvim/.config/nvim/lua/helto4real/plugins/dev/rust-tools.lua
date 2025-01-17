return {
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        dependencies = "neovim/nvim-lspconfig",
        -- config = function()
        --     require "custom.configs.rustaceanvim"
        -- end
    },
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        config = function(_, opts)
            local crates = require('crates')
            crates.setup(opts)
            -- require('cmp').setup.buffer({
            --     sources = { { name = "crates" } }
            -- })
            crates.show()
            require("core.utils").load_mappings("crates")
        end,
    }
}

--
--
-- return {
--     'simrat39/rust-tools.nvim',
--     event = "VeryLazy",
--     config = function()
--         local rt = require('rust-tools')
--         local rt_dap = require('rust-tools.dap')
--         rt.setup({
--
--             dap = {
--                 adapter = rt_dap.get_codelldb_adapter(
--                     codelldb_path, liblldb_path)
--             },
--             server = {
--                 on_attach = function(client, bufnr)
--                     -- Hover actions
--                     local nmap = function(keys, func, desc)
--                         if desc then
--                             desc = 'LSP: ' .. desc
--                         end
--                         vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--                     end
--                     nmap('<leader>e', '<cmd>TroubleToggle<CR>', '[e]rrors')
--                     nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--                     nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--                     nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--                     nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--                     nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--                     nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--                     nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--                     nmap('<leader>wws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
--                         '[W]orkspace [S]ymbols')
--                     nmap('<leader>I', require('telescope.builtin').lsp_incoming_calls, '[I]ncoming calls')
--                     -- See `:help K` for why this keymap
--                     nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--                     nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--                     -- Lesser used LSP functionality
--                     nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--                     nmap('<leader>wwa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--                     nmap('<leader>wwr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--                     nmap('<leader>wwl', function()
--                         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--                     end, '[W]orkspace [L]ist Folders')
--                     -- Create a command `:Format` local to the LSP buffer
--                     vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--                         vim.lsp.buf.format()
--                     end, { desc = 'Format current buffer with LSP' })
--
--                     vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--                     -- Code action groups
--                     vim.keymap.set("n", "<Leader>cz", rt.code_action_group.code_action_group, { buffer = bufnr })
--                     --require("lvim.lsp").common_on_attach(client, bufnr)
--                 end,
--                 settings = {
--                     ["rust-analyzer"] = {
--                         checkOnSave = {
--                             command = "clippy",
--                         },
--                     },
--                 },
--             },
--             tools = {
--                 hover_actions = {
--                     auto_focus = true,
--                 },
--             },
--         })
--     end,
--     opts = {
--
--     },
-- }

return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- event = "VeryLazy",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            'williamboman/mason.nvim',
            event = "VeryLazy",
        },
        { 'williamboman/mason-lspconfig.nvim', event = "VeryLazy" },
        { "mfussenegger/nvim-lint",            event = "VeryLazy" },
        { "rshkarin/mason-nvim-lint",          event = "VeryLazy" },
        { 'saghen/blink.cmp',                  event = "VeryLazy" },
        -- Show overloads for LSP
        -- Useful status updates for LSP
        { 'j-hui/fidget.nvim',                 event = "VeryLazy", tag = 'legacy', opts = {} },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "snacks.nvim",        words = { "Snacks" } }
                },
            },
        },
        { "williamboman/mason-lspconfig.nvim",         event = "VeryLazy" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim", event = "VeryLazy" },
        {
            "seblj/roslyn.nvim",
        },
    },

    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                -- local on_attach = function(client, bufnr)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local bufnr = event.buf

                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
                end

                --- Guard against servers without the signatureHelper capability
                -- if client ~= nil and client.server_capabilities.signatureHelpProvider then
                --     require('lsp-overloads').setup(client,
                --     {
                --         ui = {
                --             focusable = false,     -- Make the popup float focusable
                --             focus = false,        -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
                --             silent = true, -- Prevents noisy notifications (make false to help debug why signature isn't working)
                --             },
                --         keymaps = {
                --             next_signature = "<C-j>",
                --             previous_signature = "<C-k>",
                --             next_parameter = "<C-l>",
                --             previous_parameter = "<C-h>",
                --             close_signature = "<c-x>",
                --         },
                --         display_automatically = true, -- Uses trigger characters to automatically display the signature overloads when typing a method signature
                --     })
                -- end
                --
                nmap('<leader>ce', '<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>', '(e)rrors')
                nmap('<leader>cr', vim.lsp.buf.rename, '(R)ename')
                nmap('<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction')
                nmap('<leader>gd', vim.lsp.buf.definition, '(D)efinition')
                nmap('<leader>gi', function() Snacks.picker.lsp_definitions() end, '(D)efintion')
                nmap('<leader>gi', function() Snacks.picker.lsp_implementations() end, '(I)mplementation')
                nmap('<leader>gD', function() Snacks.picker.lsp_declarations() end, '(D)eclaration')
                nmap('<leader>ft', function() Snacks.picker.lsp_type_definitions() end, 'Type (D)efinitions')
                nmap('<leader>fsw', function() Snacks.picker.lsp_symbols() end, '(D)ocument')
                nmap('<leader>fsd', function() Snacks.picker.lsp_workspace_symbols() end, '(W)orkspace')
                nmap('<leader>fR', function() Snacks.picker.lsp_references() end, '(R)eferences')
                -- See `:help K` for why this keymap
                nmap('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<leader>ck', vim.lsp.buf.signature_help, 'Signature Documentation')
                -- Lesser used LSP functionality

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })

                nmap("<leader>cf", ":Format<CR>", "[F]ormat")

                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                if client and client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                -- 'omnisharp',
                -- 'roslyn',
                'html',
                'v_analyzer',
                'lua_ls',
                'yamlls',
                'gopls',
                'jsonls',
                'pyright',
                'bashls',
                -- 'roslyn',
                -- 'rust_analyzer',
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })
        -- install mason tools
        mason_tool_installer.setup({
            ensure_installed = {
                -- "markdownlint", -- prettier formatter
            },
            automatic_installation = true,
        })
        -- local lspconfig = require("lspconfig")

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.lsp.config("*", {
            capabilities = capabilities,
        })
        -- configure html server
        vim.lsp.config("html", {
            filetypes = { 'html', 'twig', 'hbs' },
        })
        vim.lsp.enable("html")
        vim.lsp.config("bashls", {})
        vim.lsp.enable("bashls")
        -- configure lua server
        vim.lsp.config("lua_ls", {
            filetypes = { 'lua' },
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        })
        vim.lsp.enable("lua_ls")
        -- configure v-language server
        vim.lsp.config("v_analyzer", {
            filetypes = { 'v' },
        })
        vim.lsp.enable("v_analyzer")
        -- configure yaml server
        vim.lsp.config("yamlls", {
            filetypes = { 'yaml', 'yml' },
        })
        vim.lsp.enable("yamlls")
        vim.lsp.config("jsonls", {})
        vim.lsp.enable("jsonls")
        vim.lsp.config("pyright", {})
        vim.lsp.enable("pyright")
        local util = require "lspconfig/util"
        vim.lsp.config("gopls", {
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        })
        vim.lsp.enable("gopls")
    end,
}

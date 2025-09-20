return {
    {
        'mfussenegger/nvim-dap',
        event = "VeryLazy",
        -- event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Creates a beautiful debugger UI
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
            -- Installs the debug adapters for you
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'theHamsta/nvim-dap-virtual-text'
            -- Add your own debuggers here
            --'leoluz/nvim-dap-go',
        },

        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'

                        -- adapter_path = "$HOME/.local/share/nvim/mason/bin/netcoredbg/netcoredbg",
            -- handle dotnet debug
            -- dap.adapters.netcoredbg = {
            --     type = 'executable',
            --     command = function()
            --         return vim.fn.expand('~/.local/share/nvim/mason/bin/netcoredbg')
            --     end,
            --     -- args = { '--interpreter=vscode' },
            -- }

            -- dap.configurations.cs = {
            --     {
            --         name = 'Launch - netcoredbg',
            --         type = 'coreclr',
            --         request = 'launch',
            --         program = function()
            --             return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            --         end,
            --         cwd = '${workspaceFolder}',
            --         stopOnEntry = false,
            --     },
            -- }

            -- vim.keymap.set('n', "<leader><F6>", function()
            --     if vim.bo.filetype ~= "rust" then
            --         vim.notify "This wasn't rust. I don't know what to do"
            --         return
            --     end
            --
            --     R("helto4real.autoload.dap").select_rust_runnable()
            -- end)

            require('mason-nvim-dap').setup {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_setup = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    -- Update this to ensure that you have the debuggers for the langs you want
                    -- 'delve',
                    'coreclr'
                },
            }

            -- Basic debugging keymaps, feel free to change to your liking!
            vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<F7>', dap.terminate, { desc = 'Debug: Terminate' })
            vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>B', function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end, { desc = 'Debug: Set Breakpoint condition' })

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup {
                -- Set icons to characters that are more likely to work in every terminal.
                --    Feel free to remove or use ones that you like more! :)
                --    Don't feel like these are good choices.
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause = '⏸',
                        play = '▶️',
                        step_into = '⏎',
                        step_over = '⏭',
                        step_out = '⏮',
                        step_back = 'b',
                        run_last = '▶▶',
                        terminate = '⏹️',
                        disconnect = 'D',
                    },
                },
            }
            --  vim.fn.sign_define("DapBreakpoint", { text = "ß", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "", linehl = "", numhl = "" })
            -- Setup cool Among Us as avatar
            --    vim.fn.sign_define("DapStopped", { text = "ඞ", texthl = "Error" })

            -- nicer icons
            vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
            vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
            require("nvim-dap-virtual-text").setup {
                enabled = true,

                -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
                enabled_commands = false,

                -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_changed_variables = true,
                highlight_new_as_changed = true,

                -- prefix virtual text with comment string
                commented = false,

                show_stop_reason = true,

                -- experimental features:
                virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
                all_frames = false,    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            }

            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
            vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            -- Install golang specific config
            -- require('dap-go').setup()
            dap.configurations.rust = {
                {
                    name = "Rust debug",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        vim.fn.jobstart('cargo build')
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
        end,

    },
    {
        'stevearc/dressing.nvim',
        event = "VeryLazy",
    },

}

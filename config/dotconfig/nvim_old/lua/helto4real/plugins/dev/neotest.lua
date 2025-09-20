return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "Issafalcon/neotest-dotnet",
    },
    config = function()
        local neotest = require("neotest")
        local neodotnet = require("neotest-dotnet")
        neotest.setup({
            -- add any options here
            discovery = {
                -- Drastically improve performance in ginormous projects by
                -- only AST-parsing the currently opened buffer.
                enabled = false,
                -- Number of workers to parse files concurrently.
                -- A value of 0 automatically assigns number based on CPU.
                -- Set to 1 if experiencing lag.
                concurrent = 1,
            },
            running = {
                -- Run tests concurrently when an adapter provides multiple commands to run.
                concurrent = true,
            },
            summary = {
                -- Enable/disable animation of icons.
                animated = false,
            },
            -- log_level = 1,
            adapters = {
                neodotnet({
                    dap = {
                        -- Extra arguments for nvim-dap configuration
                        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                        args = { justMyCode = false },
                        -- Enter the name of your dap adapter, the default value is netcoredbg
                        adapter_name = "coreclr",
                        -- adapter_path = "$HOME/.local/share/nvim/mason/bin/netcoredbg/netcoredbg",
                    },
                    -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
                    -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
                    -- custom_attributes = {
                    --     xunit = { "MyCustomFactAttribute" },
                    --     nunit = { "MyCustomTestAttribute" },
                    --     mstest = { "MyCustomTestMethodAttribute" }
                    -- },
                    -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
                    -- dotnet_additional_args = {
                    --     "--verbosity detailed"
                    -- },
                    -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
                    -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
                    --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
                    discovery_root = "solution" -- Default
                }),
            },
            -- icons = {
            --     expanded = "",
            --     child_prefix = "",
            --     child_indent = "",
            --     final_child_prefix = "",
            --     non_collapsible = "",
            --     collapsed = "",
            --     passed = "",
            --     running = "",
            --     failed = "",
            --     unknown = "",
            --     skipped = "",
            -- },
        })
    end,
    keys = {
        {
            "<leader>ctr",
            function() require("neotest").run.run() end,
            desc = "[R]un tests",
        },
        {
            "<leader>ctd",
            function() require("neotest").run.run({ strategy = "dap" }) end,
            desc = "[D]ebug test",
        },
        {
            "<leader>ctc",
            function() require("neotest").run.run(vim.fn.expand("%")) end,
            desc = "Run [C]urrent file",
        },
        {
            "<leader>cts",
            function() require("neotest").run.stop() end,
            desc = "[S]top",
        },
        {
            "<leader>cta",
            function() require("neotest").run.attach() end,
            desc = "[A]ttach",
        },
        {
            "<leader>cty",
            function() require("neotest").summary.toggle() end,
            desc = "Summar[y]",
        },
        {
            "<leader>ctu",
            function() require("neotest").status.toggle() end,
            desc = "Stat[u]s",
        },
        {
            "<leader>cti",
            function() require("neotest").diagnostic.toggle() end,
            desc = "D[i]agnistic",
        },
    },
}

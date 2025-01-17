return {
    {
        'tpope/vim-fugitive',
        event = "VeryLazy",
    },
    {
        'tpope/vim-rhubarb',
        event = "VeryLazy",
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        'pwntester/octo.nvim',
        event = "VeryLazy",
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require "octo".setup()
        end,
        keys = {
            {
                "<leader>cghrb",
                "<cmd>Octo repo browser<CR>",
                desc = "[B]rowser",
            },
            {
                "<leader>cghrl",
                "<cmd>Octo repo list<CR>",
                desc = "[L]ist",
            },
            {
                "<leader>cghrv",
                "<cmd>Octo repo view<CR>",
                desc = "[V]iew",
            },
            {
                "<leader>cghil",
                "<cmd>Octo issue list<CR>",
                desc = "[L]ist",
            },
            {
                "<leader>cghis",
                "<cmd>Octo issue search<CR>",
                desc = "[S]earch",
            },
            {
                "<leader>cghib",
                "<cmd>Octo issue browser<CR>",
                desc = "[B]rowser",
            },
            {
                "<leader>cghic",
                "<cmd>Octo issue create<CR>",
                desc = "[C]reate",
            },
            {
                "<leader>cghpl",
                "<cmd>Octo pr list<CR>",
                desc = "[L]ist",
            },
            {
                "<leader>cghpn",
                "<cmd>Octo pr create<CR>",
                desc = "Create [N]ew",
            },
            {
                "<leader>cghpa",
                "<cmd>Octo pr reload<CR>",
                desc = "Relo[a]d",
            },
            {
                "<leader>cghpc",
                "<cmd>Octo pr changes<CR>",
                desc = "[C]hanges",
            },
            {
                "<leader>cghpd",
                "<cmd>Octo pr diff<CR>",
                desc = "[D]iff",
            },
            {
                "<leader>cghpb",
                "<cmd>Octo pr browser<CR>",
                desc = "[B]rowser",
            },
            {
                "<leader>cghpk",
                "<cmd>Octo pr checks<CR>",
                desc = "Chec[k]s",
            },
            {
                "<leader>cghph",
                "<cmd>Octo pr checkout<CR>",
                desc = "C[h]ech out",
            },
            {
                "<leader>cghpm",
                "<cmd>Octo pr merge<CR>",
                desc = "[M]erge",
            },
            {
                "<leader>cghpe",
                "<cmd>Octo pr ready<CR>",
                desc = "[R]eady",
            },
            {
                "<leader>cghpd",
                "<cmd>Octo pr draft<CR>",
                desc = "[D]raft",
            },

            {
                "<leader>cghprs",
                "<cmd>Octo review start<CR>",
                desc = "[S]tart",
            },
            {
                "<leader>cghprr",
                "<cmd>Octo review resume<CR>",
                desc = "[R]esume",
            },
            {
                "<leader>cghprx",
                "<cmd>Octo review close<CR>",
                desc = "Close[X]",
            },
            {
                "<leader>cghprd",
                "<cmd>Octo review discard<CR>",
                desc = "[D]iscard",
            },
            {
                "<leader>cghpro",
                "<cmd>Octo review commit<CR>",
                desc = "C[O]mmit",
            },
            {
                "<leader>cghca",
                "<cmd>Octo comment add<CR>",
                desc = "[A]dd",
            },
            {
                "<leader>cghcd",
                "<cmd>Octo comment delete<CR>",
                desc = "[D]elete",
            },
            {
                "<leader>cghla",
                "<cmd>Octo label add<CR>",
                desc = "[A]dd",
            },
            {
                "<leader>cghlr",
                "<cmd>Octo label remove<CR>",
                desc = "[R]emove",
            },
            {
                "<leader>cghe",
                "<cmd>Octo reaction<CR>",
                desc = "R[e]action",
            },
            {
                "<leader>cghs",
                "<cmd>Octo search<CR>",
                desc = "[S]earch",
            },

        },
    },
    {
        "NeogitOrg/neogit",
        opts = {
            commit_editor = {
                kind = "floating",
                show_staged_diff = true,
                -- Accepted values:
                -- "split" to show the staged diff below the commit editor
                -- "vsplit" to show it to the right
                -- "split_above" Like :top split
                -- "vsplit_left" like :vsplit, but open to the left
                -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
                staged_diff_split_kind = "split",
                spell_check = true,
            },
        },
        keys = {
            {
                "<leader>cgg",
                function()
                    -- require("neogit").open({ kind = "split" })
                    require("neogit").open({ kind = "floating" })
                end,
                desc = "(G)it Neo(g)it",
            },
            {
                "<leader>cgc",
                function()
                    -- require("neogit").open({ "commit", "-a", kind = "split"})
                    require("neogit").open({ "commit", "-a", kind = "floating" })
                end,
                desc = "(G)it (C)ommit",
            },
            {
                "<leader>cgd",
                function()
                    -- require("neogit").open({ "diff", kind = "split"})
                    require("neogit").open({ "diff", kind = "floating" })
                end,
                desc = "(G)it (D)iff",
            },
            {
                "<leader>cgp",
                function()
                    require("neogit").open({ "push" })
                end,
                desc = "(G)it (P)ush",
            },
            {
                "<leader>cgw",
                function()
                    require("neogit").open({ "worktree" })
                end,
                desc = "(G)it (W)orktree",
            },
            {
                "<leader>cgb",
                function()
                    require("neogit").open({ "branch", kind = "floating" })
                end,
                desc = "(G)it (B)ranch",
            },
            {
                "<leader>cgr",
                function()
                    require("neogit").open({ "rebase", kind = "floating" })
                end,
                desc = "(G)it (R)ebase",
            },
        },
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true
    }
}

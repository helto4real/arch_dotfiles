-- return {
--     "folke/trouble.nvim",
--     --dependencies = { "nvim-tree/nvim-web-devicons" },
--     event = "VeryLazy",
--     keys = {
--             {
--                 mode = { 'n' },
--                 '<Leader>co',
--                 '<cmd>Trouble<cr>',
--                 desc = 'Tr[o]uble',
--             },
--     },
--     opts = {
--         -- your configuration comes here
--         -- or leave it empty to use the default settings
--         -- refer to the configuration section below
--     },
-- }
return {
  "folke/trouble.nvim",
  optional = true,
  specs = {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "trouble_open",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      })
    end,
  },
}

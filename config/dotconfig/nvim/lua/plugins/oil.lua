return {
  "stevearc/oil.nvim",
  -- opts = {
  -- },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open Oil file manager" })
    require("oil").setup({
      keymaps = {
        ["gb?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["gbr"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gbs"] = { "actions.change_sort", mode = "n" },
        ["gbx"] = "actions.open_external",
        ["gb."] = { "actions.toggle_hidden", mode = "n" },
        ["gb\\"] = { "actions.toggle_trash", mode = "n" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
      -- buf_options = {
      --     buflisted = false,
      --     bifhidden = "hide",
      -- },
      view_options = {
        show_hidden = true,
      },
    })
  end,
}

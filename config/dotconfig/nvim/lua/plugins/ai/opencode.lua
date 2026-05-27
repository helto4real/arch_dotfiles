return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },

  keys = {
    { "<leader>ao", "", desc = "+OpenCode", mode = { "n", "v" } },
    {
      "<leader>aoo",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle OpenCode",
      mode = { "n" },
    },
    {
      "<leader>aoA",
      function()
        require("opencode").ask()
      end,
      desc = "Ask OpenCode",
      mode = { "n" },
    },
    {
      "<leader>aoa",
      function()
        require("opencode").ask("@cursor: ")
      end,
      desc = "Ask OpenCode about this",
      mode = { "n" },
    },
    {
      "<leader>aoa",
      function()
        require("opencode").ask("@selection: ")
      end,
      desc = "Ask opencode about selection",
      mode = { "v" },
    },
    {
      "<leader>aon",
      function()
        require("opencode").command("session_new")
      end,
      desc = "New open code session",
      mode = { "n" },
    },
    {
      "<leader>aoy",
      function()
        require("opencode").command("messages_copy")
      end,
      desc = "Copy last opencode responsee",
      mode = { "n" },
    },
    {
      "<leader>aos",
      function()
        require("opencode").select()
      end,
      desc = "Select opencode prompt",
      mode = { "n", "v" },
    },
    {
      "<leader>aoe",
      function()
        require("opencode").prompt("Explain @cursor and its context")
      end,
      desc = "Explain this code",
      mode = { "n" },
    },
  },
  config = function()
    -- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`
    }

    -- Required for `opts.auto_reload`
    vim.opt.autoread = true

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("messages_half_page_up")
    end, { desc = "Messages half page up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("messages_half_page_down")
    end, { desc = "Messages half page down" })
  end,
}

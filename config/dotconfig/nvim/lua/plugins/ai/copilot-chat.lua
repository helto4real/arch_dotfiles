return {
  "CopilotC-Nvim/CopilotChat.nvim",
  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    { "<leader>ac", "", desc = "+Copilot Chat", mode = { "n", "v" } },
    { "<leader>aa", false, desc = "CopilotChat is namespaced under <leader>ac", mode = { "n", "v", "x" } },
    { "<leader>ax", false, desc = "CopilotChat is namespaced under <leader>ac", mode = { "n", "v", "x" } },
    { "<leader>aq", false, desc = "CopilotChat is namespaced under <leader>ac", mode = { "n", "v", "x" } },
    { "<leader>ap", false, desc = "CopilotChat is namespaced under <leader>ac", mode = { "n", "v", "x" } },
    {
      "<leader>aca",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>acx",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>acq",
      function()
        vim.ui.input({
          prompt = "Quick Chat: ",
        }, function(input)
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end)
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>acp",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "v" },
    },
  },
}

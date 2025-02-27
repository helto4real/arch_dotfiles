return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    keys = {
        {
            "<leader>ccq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                end
            end,
            desc = "CopilotChat - Quick chat",
        },
        {
            "<leader>cch",
            function()
                local actions = require("CopilotChat.actions")
                require("CopilotChat.integrations.telescope").pick(actions.help_actions())
            end,
            desc = "CopilotChat - [H]elp actions",
        },
        {
            "<leader>cca",
            function()
                local actions = require("CopilotChat.actions")
                require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            end,
            desc = "CopilotChat - Prompt [A]ctions",
        },
        {
            "<leader>ccc",
            ":CopilotChatCommit<CR>",
            desc = "CopilotChat - [C]ommit Message",
        },
        {
            "<leader>ccd",
            ":CopilotChatDocs<CR>",
            desc = "CopilotChat - [D]ocumentation",
        },
        {
            "<leader>ccf",
            ":CopilotChatFixDiagnostic<CR>",
            desc = "CopilotChat - [F]ix Diagnostic",
        },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
        model = "claude-3.7-sonnet", -- See Configuration section for options
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}

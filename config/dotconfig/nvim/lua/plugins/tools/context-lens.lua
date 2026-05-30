return {
  dir = "/home/thhel/git/helto-nvim-context",
  name = "context-lens.nvim",
  event = "VeryLazy",
  init = function()
    local group = vim.api.nvim_create_augroup("ContextLensKeymaps", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(args)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            vim.keymap.set("n", "<leader>cc", "<cmd>ContextLensToggle<cr>", {
              buffer = args.buf,
              desc = "Context Lens",
              silent = true,
            })
          end
        end)
      end,
    })
  end,
  config = function()
    require("context-lens").setup({})
  end,
  keys = {
    { "<leader>cc", "<cmd>ContextLensToggle<cr>", desc = "Context Lens" },
  },
}

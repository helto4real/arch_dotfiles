vim.cmd("source ~/.config/nvim/lua/plugins/md-preview.vim")

return {
  "iamcco/markdown-preview.nvim",
  -- event = "VeryLazy",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      mode = { "n" },
      "<cmd>MarkdownPreviewToggle<CR>",
      desc = "Markdown Preview toggle",
    },
  },
}

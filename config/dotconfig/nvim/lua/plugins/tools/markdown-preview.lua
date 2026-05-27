return {
  "iamcco/markdown-preview.nvim",
  -- event = "VeryLazy",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    _G.open_markdown_preview = function(url)
      vim.fn.jobstart({ "xdg-open", url }, { detach = true })
    end

    vim.cmd([[
      function! OpenMarkdownPreview(url) abort
        call v:lua.open_markdown_preview(a:url)
      endfunction
    ]])

    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
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

vim.cmd('source ~/.config/nvim/lua/helto4real/plugins/md-preview.vim')

return {
    "iamcco/markdown-preview.nvim",
    -- event = "VeryLazy",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_browser = "/usr/bin/wslview"
        vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
    end,
    ft = { "markdown" },
    keys = {
        {
            "<leader>mp",
            mode = { "n" },
            "<cmd>MarkdownPreviewToggle<CR>",
            desc = "Markdown Preview toggle"
        },
    },
}

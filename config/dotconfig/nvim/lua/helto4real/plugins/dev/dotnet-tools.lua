return {
    -- dir = "~/git/dotnet-tools",
    "helto4real/dotnet-tools.vim",
    event = "VeryLazy",
    dependencieset = {
        "plenary.nvim",
    },
    init = function()
        require("dotnet-tools").setup({})
    end,
    keys = {
        {
            "<leader>cdt",
            mode = { "n", "o", "x" },
            ":DotNetToolsTest<CR>",
            desc = "Dotnet test"
        },
        {
            "<leader>cdo",
            mode = { "n", "o", "x" },
            ":DotNetToolsOutdated<CR>",
            desc = "Dotnet outdated"
        },
        {
            "<leader>cdu",
            mode = { "n", "o", "x" },
            ":DotNetToolsOutdatedUpgrade<CR>",
            desc = "Dotnet outdated upgrade"
        },
        {
            "<leader>cdb",
            mode = { "n", "o", "x" },
            ":DotNetToolsBuild<CR>",
            desc = "[B]uild"
        },
    },
}

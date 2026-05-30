return {
  dir = "/home/thhel/git/dotnet-tools",
  name = "dotnet-tools.vim",
  event = "VeryLazy",
  dependencies = {
    "plenary.nvim",
  },
  config = function()
    require("dotnet-tools").setup({})
  end,
  keys = {

    { "<leader>cd", "", desc = "+dotnet" },
    {
      "<leader>cdt",
      mode = { "n", "o", "x" },
      ":DotNetToolsTest<CR>",
      desc = "Dotnet test",
    },
    {
      "<leader>cdT",
      mode = { "n", "o", "x" },
      ":DotNetToolsTestTreeToggle<CR>",
      desc = "Toggle dotnet test tree",
    },
    {
      "<leader>cdo",
      mode = { "n", "o", "x" },
      ":DotNetToolsOutdated<CR>",
      desc = "Dotnet outdated",
    },
    {
      "<leader>cdu",
      mode = { "n", "o", "x" },
      ":DotNetToolsOutdatedUpgrade<CR>",
      desc = "Dotnet outdated upgrade",
    },
    {
      "<leader>cdb",
      mode = { "n", "o", "x" },
      ":DotNetToolsBuild<CR>",
      desc = "[B]uild",
    },
  },
}

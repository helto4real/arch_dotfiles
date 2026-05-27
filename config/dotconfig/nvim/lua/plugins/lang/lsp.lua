return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            -- Ask pyenv for the specific python path for the current directory
            local handle = io.popen("pyenv which python 2>/dev/null")
            if handle then
              local res = handle:read("*a")
              handle:close()
              local path = res:gsub("%s+", "")
              if path ~= "" then
                config.settings.python.pythonPath = path
              end
            end
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
}

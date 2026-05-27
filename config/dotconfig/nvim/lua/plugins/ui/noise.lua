return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = {
        -- There is a bug in the c# lsb that requires me to disable this
        enabled = false,
      },
    },
  },
}

return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = {
      preset = "default",
      ["<c-l>"] = { "show", "show_documentation", "hide_documentation" },
    }
  end,
}

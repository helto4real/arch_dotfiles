-- return {
--     -- Tokyo night theme
--     'folke/tokyonight.nvim',
--     lazy = false,
--     priority = 1000,
--     config = function()
--         -- your config
--         require('tokyonight').setup({
--             style = "night",
--             transparent = false,
--             on_colors = function(colors)
--                 colors.bg = "#191a25"
--             end,
--             on_highlights = function (hl, c)
--                hl.CursorLine = {
--                     bg = "#1f202e",
--                 }
--                hl.CmpNormal = {
--                     bg = "#292b3d",
--                 }
--             end,
--         })
--
--     end,
-- }
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
        require("catppuccin").setup(
            {
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = {    -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                float = {
                    transparent = false,        -- enable transparent floating windows
                    solid = false,              -- use solid styling for floating windows, see |winborder|
                },
                show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
                term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false,            -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
                },
                no_italic = false,              -- Force no italic
                no_bold = false,                -- Force no bold
                no_underline = false,           -- Force no underline
                styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    -- miscs = {}, -- Uncomment to turn off hard-coded styles
                },
                color_overrides = {},
                custom_highlights = {},
                default_integrations = true,
                auto_integrations = false,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    --                     harpoon = true,
                    markdown = true,
                    neogit = true,
                    noice = true,
                    neotest = true,
                    copilot = true,
                    dap = true,
                    dap_ui = true,
                    octo = true,
                    render_markdown = true,
                    lsp_trouble = true,
                    which_key = true,

                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })
        vim.cmd.colorscheme "catppuccin"

    end,
}

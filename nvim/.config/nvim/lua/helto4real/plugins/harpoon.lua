return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set(
            "n",
            "<leader>hm",
            "<cmd>lua require('harpoon.mark').add_file()<cr>",
            { desc = "Mark file with harpoon" }
        )
        keymap.set("n", "<leader>hj", "<cmd>lua require('harpoon.ui').nav_next()<cr>",
            { desc = "Go to next [H]arpoon mark" })

        keymap.set(
            "n",
            "<leader>hk",
            "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
            { desc = "Go to previous [H]arpoon mark" }
        )
        keymap.set(
            "n",
            "<leader>hh",
            "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
            { desc = "Toggle [H]arpoon mark" }
        )
    end,
}

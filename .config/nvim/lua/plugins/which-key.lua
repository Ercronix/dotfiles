return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 300, -- ms after a prefix key before the popup appears
        spec = {
            { "<leader>c", group = "Copy" },
            { "<leader>d", group = "Debug / Diagnostics" },
            { "<leader>e", group = "Explorer (nvim-tree)" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Git hunks" },
            { "<leader>l", group = "Lint / Lazygit" },
            { "<leader>m", group = "Format" },
            { "<leader>p", group = "Pick / Find" },
            { "<leader>r", group = "Rename / Restart" },
            { "<leader>t", group = "Terminal / Toggles" },
            { "<leader>v", group = "LSP / Help" },
            { "<leader>x", group = "Trouble" },
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer-local keymaps",
        },
    },
}

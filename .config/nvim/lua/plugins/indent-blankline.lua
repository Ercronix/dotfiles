return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
        local hooks = require("ibl.hooks")

        -- Single indent color
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "IndentLine", { fg = "#3b4261" }) -- subtle gray
            vim.api.nvim_set_hl(0, "CurrentScope", { fg = "#7aa2f7" }) -- highlight for current function/block
        end)

        require("ibl").setup({
            indent = {
                char = "│",
                tab_char = "│",
                highlight = { "IndentLine" },
            },
            scope = {
                enabled = true,
                show_start = false, -- cleaner look
                show_end = false,
                highlight = { "CurrentScope" }, -- only current scope highlighted
            },
            exclude = {
                filetypes = {
                    "help",
                    "dashboard",
                    "lazy",
                    "mason",
                    "oil",
                    "trouble",
                    "toggleterm",
                    "TelescopePrompt",
                    "NvimTree",
                    "alpha",
                    "",
                },
            },
        })
    end,
}

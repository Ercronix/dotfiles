return {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("illuminate").configure({
            -- Providers in order of priority
            providers = {
                "lsp",       -- uses LSP for most accurate references
                "treesitter", -- fallback to treesitter
                "regex",     -- last resort regex match
            },
            delay = 100, -- ms delay before highlighting (lower = snappier)
            filetype_overrides = {},
            filetypes_denylist = {
                "oil",
                "mason",
                "lazy",
                "help",
                "dashboard",
                "TelescopePrompt",
                "trouble",
                "NvimTree",
                "",
            },
            under_cursor = true, -- highlight the word under cursor too
            large_file_cutoff = 2000, -- disable for files over 2000 lines (performance)
            large_file_overrides = {
                providers = { "regex" }, -- only regex on large files
            },
            min_count_to_highlight = 1, -- highlight even if only 1 occurrence
        })

        -- Customize highlight appearance to complement tokyonight
        vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#2e1a64", underline = false })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#2e3c64", underline = false })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3d2b55", underline = false })

        -- Keymaps to jump between references (like WebStorm's F2 / Shift+F2)
        vim.keymap.set("n", "<leader>]r", function()
            require("illuminate").goto_next_reference()
        end, { desc = "Go to next reference" })

        vim.keymap.set("n", "<leader>[r", function()
            require("illuminate").goto_prev_reference()
        end, { desc = "Go to previous reference" })
    end,
}

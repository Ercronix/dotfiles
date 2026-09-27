return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false, -- main branch does not support lazy-loading
        build = ":TSUpdate",
        config = function()
            -- parsers to install (async, no-op if already installed)
            require("nvim-treesitter").install({
                "json",
                "javascript",
                "typescript",
                "tsx",
                "go",
                "yaml",
                "html",
                "css",
                "python",
                "http",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "java",
                "rust",
                "ron",
            })

            -- enable highlighting + indentation for any filetype with a parser
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
                callback = function(args)
                    if pcall(vim.treesitter.start, args.buf) then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- incremental selection (built into nvim 0.12 as visual an/in)
            vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
            vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand node selection" })
            vim.keymap.set("x", "<C-backspace>", "in", { remap = true, desc = "Shrink node selection" })
        end,
    },
    -- NOTE: js,ts,jsx,tsx Auto Close Tags
    {
        "windwp/nvim-ts-autotag",
        enabled = true,
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
        config = function()
            -- Independent nvim-ts-autotag setup
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,           -- Auto-close tags
                    enable_rename = true,          -- Auto-rename pairs
                    enable_close_on_slash = false, -- Disable auto-close on trailing `</`
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true, -- Disable auto-closing for HTML
                    },
                    ["typescriptreact"] = {
                        enable_close = true, -- Explicitly enable auto-closing (optional, defaults to `true`)
                    },
                },
            })

            -- Guard rename_tag against a nil treesitter parser
            -- (upstream pcall returns ok=true when get_parser returns nil, then crashes on :parse)
            local autotag_internal = require("nvim-ts-autotag.internal")
            local original_rename_tag = autotag_internal.rename_tag
            autotag_internal.rename_tag = function(...)
                local args = { ... }
                pcall(function()
                    original_rename_tag(unpack(args))
                end)
            end
        end,
    },
}

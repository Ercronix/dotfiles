return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("trouble").setup({
            modes = {
                -- Diagnostics for current buffer only (like WebStorm's file-level Problems tab)
                diagnostics_buffer = {
                    mode = "diagnostics",
                    filter = { buf = 0 },
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.45,
                    },
                },
            },
            focus = true,           -- auto-focus trouble window when opened
            restore = true,         -- restore last position when reopening
            follow = true,          -- follow current item on cursor move
            indent_guides = true,   -- show indent guides in trouble list
            max_items = 200,
            auto_close = false,     -- keep open even when no more items
            auto_preview = true,    -- auto-preview item under cursor
            auto_refresh = true,    -- refresh when diagnostics change
            icons = {
                indent = {
                    top           = "│ ",
                    middle        = "├╴",
                    last          = "└╴",
                    fold_open     = " ",
                    fold_closed   = " ",
                    ws            = "  ",
                },
                folder_closed = " ",
                folder_open   = " ",
                kinds = {
                    Array         = " ",
                    Boolean       = "󰨙 ",
                    Class         = " ",
                    Constant      = "󰏿 ",
                    Constructor   = " ",
                    Enum          = " ",
                    EnumMember    = " ",
                    Event         = " ",
                    Field         = " ",
                    File          = " ",
                    Function      = "󰊕 ",
                    Interface     = " ",
                    Key           = " ",
                    Method        = "󰊕 ",
                    Module        = " ",
                    Namespace     = "󰦮 ",
                    Null          = " ",
                    Number        = "󰎠 ",
                    Object        = " ",
                    Operator      = " ",
                    Package       = " ",
                    Property      = " ",
                    String        = " ",
                    Struct        = "󰆼 ",
                    TypeParameter = " ",
                    Variable      = "󰀫 ",
                },
            },
        })

        -- Keymaps
        -- Workspace-wide diagnostics (all files) — like WebStorm's full Problems panel
        vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>",
            { desc = "Workspace diagnostics (Trouble)" })

        -- Buffer-only diagnostics
        vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics_buffer toggle<CR>",
            { desc = "Buffer diagnostics (Trouble)" })

        -- LSP references, definitions, implementations in trouble panel
        vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>",
            { desc = "LSP references (Trouble)" })
        vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",
            { desc = "Symbols outline (Trouble)" })

        -- Quickfix and loclist via trouble
        vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>",
            { desc = "Quickfix list (Trouble)" })
        vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>",
            { desc = "Location list (Trouble)" })

        -- Navigate trouble items when a trouble list is open, otherwise jump diagnostics
        vim.keymap.set("n", "[d", function()
            local trouble = require("trouble")
            if trouble.is_open() then
                trouble.prev({ skip_groups = true, jump = true })
            else
                vim.diagnostic.jump({ count = -1, float = true })
            end
        end, { desc = "Prev trouble item / diagnostic" })

        vim.keymap.set("n", "]d", function()
            local trouble = require("trouble")
            if trouble.is_open() then
                trouble.next({ skip_groups = true, jump = true })
            else
                vim.diagnostic.jump({ count = 1, float = true })
            end
        end, { desc = "Next trouble item / diagnostic" })
    end,
}

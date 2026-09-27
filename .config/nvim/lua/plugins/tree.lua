return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()

        vim.fn.sign_define("NvimTreeDiagnosticErrorIcon",   { text = " ", texthl = "DiagnosticError" })
        vim.fn.sign_define("NvimTreeDiagnosticWarnIcon",    { text = " ", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("NvimTreeDiagnosticHintIcon",    { text = "󰠠 ", texthl = "DiagnosticHint" })
        vim.fn.sign_define("NvimTreeDiagnosticInfoIcon",    { text = " ", texthl = "DiagnosticInfo" })
        -- disable netrw (required by nvim-tree)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            hijack_directories = { enable = false }, -- oil handles directories
            view = {
                width = 35,
                side = "left",
                preserve_window_proportions = true,
            },
            renderer = {
                root_folder_label = ":~:s?$?/..?", -- show shortened root path
                highlight_git = true,
                highlight_opened_files = "name",   -- highlight files open in a buffer
                highlight_modified = "name",
                indent_markers = {
                    enable = true,
                    icons = {
                        corner = "└",
                        edge = "│",
                        item = "│",
                        bottom = "─",
                        none = " ",
                    },
                },
                icons = {
                    git_placement = "after",       -- git icon after filename
                    modified_placement = "after",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        modified = true,
                    },
                    glyphs = {
                        default = "󰈚",
                        symlink = "",
                        bookmark = "󰆤",
                        modified = "●",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
            },
            filters = {
                dotfiles = false, -- show dotfiles (toggle with H)
                custom = {
                    "^.git$",
                    "node_modules",
                    ".cache",
                },
            },
            git = {
                enable = true,
                ignore = false, -- show git-ignored files (dimmed)
                timeout = 400,
            },
            modified = {
                enable = true,
            },
            actions = {
                open_file = {
                    quit_on_open = false, -- keep tree open after opening a file
                    window_picker = {
                        enable = true,    -- pick which window to open file in
                    },
                },
            },
            update_focused_file = {
                enable = true,  -- auto-reveal current file in tree
                update_root = false,
            },
            diagnostics = {
                enable = true,  -- show LSP diagnostic icons in tree
                show_on_dirs = true,
                icons = {
                    hint = "󰠠",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            -- sync tree root with oil.nvim / project root changes
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>",   { desc = "Toggle file tree" })
        vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal current file in tree" })
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file tree" })
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>",  { desc = "Refresh file tree" })
    end,
}

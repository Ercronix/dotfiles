return {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-\>]],     -- toggle terminal with Ctrl+\
            hide_numbers = true,           -- hide line numbers in terminal
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,        -- apply open_mapping in insert mode too
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,           -- remember terminal mode (insert/normal)
            direction = "float",           -- default: float | horizontal | vertical | tab
            close_on_exit = true,
            shell = vim.o.shell,
            auto_scroll = true,
            float_opts = {
                border = "curved",
                winblend = 0,              -- transparent to match your theme
                width = function()
                    return math.floor(vim.o.columns * 0.85)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.85)
                end,
                title_pos = "center",
            },
            winbar = {
                enabled = false,
            },
        })

        -- Easy navigation out of terminal back to editor
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]],       opts) -- esc to normal mode
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        -- Named terminal instances
        local Terminal = require("toggleterm.terminal").Terminal

        -- Node REPL
        local node = Terminal:new({
            cmd = "node",
            direction = "float",
            float_opts = { border = "curved" },
        })

        -- Python REPL
        local python = Terminal:new({
            cmd = "python3",
            direction = "float",
            float_opts = { border = "curved" },
        })

        -- Horizontal terminal (stays at bottom like WebStorm's terminal panel)
        local bottom_term = Terminal:new({
            direction = "horizontal",
            size = 15,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>tt",  "<cmd>ToggleTerm direction=float<CR>",      { desc = "Float terminal" })
        vim.keymap.set("n", "<leader>th",  "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
        vim.keymap.set("n", "<leader>tv",  "<cmd>ToggleTerm direction=vertical<CR>",   { desc = "Vertical terminal" })
        --vim.keymap.set("n", "<leader>tf",  "<cmd>ToggleTerm direction=tab<CR>",        { desc = "Tab terminal" })

        vim.keymap.set("n", "<leader>tn", function() node:toggle() end,        { desc = "Node REPL" })
        vim.keymap.set("n", "<leader>tp", function() python:toggle() end,      { desc = "Python REPL" })

        -- Send current line or visual selection to terminal
        vim.keymap.set("n", "<leader>ts", "<cmd>ToggleTermSendCurrentLine<CR>",     { desc = "Send line to terminal" })
        vim.keymap.set("v", "<leader>ts", "<cmd>ToggleTermSendVisualSelection<CR>", { desc = "Send selection to terminal" })
    end,
}

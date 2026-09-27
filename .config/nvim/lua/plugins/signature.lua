return {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
        require("lsp_signature").setup({
            bind = true,
            handler_opts = {
                border = "rounded",
            },
            floating_window = true,
            floating_window_above_cur_line = true, -- try to place window above cursor
            floating_window_off_x = 1,
            floating_window_off_y = -2,
            fix_pos = false,        -- reposition window as signature changes
            auto_close_after = nil, -- keep open until you leave insert mode
            close_timeout = 4000,
            hint_enable = true,     -- virtual text hint showing active parameter
            hint_prefix = {
                above = "↙ ",
                current = "← ",
                below = "↗ ",
            },
            hint_scheme = "Comment",
            hint_inline = function() return false end, -- set to true for inline virtual text
            hi_parameter = "LspSignatureActiveParameter", -- highlight active param
            max_height = 12,
            max_width = 80,
            wrap = true,
            padding = " ",
            shadow_blend = 36,
            shadow_guibg = "Black",
            timer_interval = 200,
            toggle_key = "<C-k>",       -- toggle signature window in insert mode
            toggle_key_flip_floatwin_setting = true,
            select_signature_key = "<M-n>", -- cycle through overloaded signatures
            move_cursor_key = nil,
        })

        -- Highlight the active parameter with a distinct color (tokyonight-friendly)
        vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
            fg = "#ff9e64",
            bold = true,
            underline = true,
        })
    end,
}

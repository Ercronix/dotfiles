local opts = {noremap = true, silent = true}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "moves lines down in v mode"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "moves lines up in v mode"})

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("x", "<leader>p", [["_dP"]], { desc = "Paste without yanking" })

vim.keymap.set("v", "p", '"_dP', opts)

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-c>", ":nohl<CR>", {desc = "Clear search hl", silent = true})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
end, { desc = "Format file or range (conform)" })
vim.keymap.set("n", "x", '"_x', opts)
--Tabs
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],{ desc = "Replace word cursor is on globally" })

-- Executes shell command from in here making file executable
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>cp", function()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })










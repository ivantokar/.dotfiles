-- Keymaps are automatically loaded on the VeryLazy event.

-- Move selected lines while preserving the selection.
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Paste without replacing the system clipboard contents.
vim.keymap.set("x", "<leader>p", [["_dP]])

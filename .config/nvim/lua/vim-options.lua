-- Basic
vim.opt.nu = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.softtabstop = 4 -- Number of spaces tabs count for
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart indentation
vim.opt.wrap = false -- No wrap
vim.opt.swapfile = false -- No swap files
vim.opt.backup = false -- No backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Save undo history
vim.opt.undofile = true -- Save undo history
vim.opt.hlsearch = false -- Highlight search results
vim.opt.incsearch = true -- Incremental search
vim.opt.termguicolors = true -- True color support
vim.opt.scrolloff = 8 -- Lines of context
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.isfname:append("@-@") -- Allow @ in file names
vim.opt.updatetime = 50 -- Faster completion
vim.opt.colorcolumn = "80" -- Show a column at 80 characters
vim.opt.cursorline = true -- Highlight the current line
vim.opt.showmode = true -- Show the current mode
-- vim.opt.listchars = "tab:|·,trail:·,extends:→,precedes:←,nbsp:␣" -- Show special characters
-- vim.opt.list = true -- Show special characters
vim.opt.spell = true -- Enable spell check
vim.opt.spelllang = "en_us" -- Set spell check language

-- Set leader key
vim.g.mapleader = " "

-- Move lines up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Move lines up and down and set line in the middle of the screen
vim.keymap.set("n", "J", "mzJ`z")

-- Move up and down and set line in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Paste from system clipboard multiple times
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Move to next and previous location in quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Move to next and previous location in quickfix list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Move to next and previous buffer
vim.keymap.set("n", "<leader><tab>", "<cmd>bnext<CR>")

-- Use the space leader before LazyVim creates its keymaps.
vim.g.mapleader = " "

-- Show relative line numbers and keep the active cursor line visible.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Use four-space indentation and never insert literal tab characters.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Keep editing and search behaviour consistent with the previous configuration.
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Set display and completion preferences.
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.showmode = false
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

return {
	{
		-- Startify for start screen

		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		-- Undotree for undo history

		"mbbill/undotree",

		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.g.undotree_SplitWidth = 40
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_HighlightChangedWithSign = 1

			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		-- Which key for keybindings

		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},

		setup = function()
			local wk = require("which-key")

			wk.setup({})
		end,
	},
}

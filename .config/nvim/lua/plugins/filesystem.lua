return {
	{
		"stevearc/oil.nvim",

		config = function()
			local oil = require("oil")
			oil.setup()
			vim.keymap.set("n", "-", oil.toggle_float, {})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},

		config = function()
			vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
			vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

			require("neo-tree").setup({
				-- popup_border_style = "rounded",

				window = {
					position = "left",
					width = 50,
				},
			})
		end,
	},
}

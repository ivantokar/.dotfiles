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
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},

		config = function()
			vim.keymap.set("n", "<leader>t", ":Neotree toggle filesystem left<CR>", {})
			vim.keymap.set("n", "<leader>b", ":Neotree toggle buffers bottom<CR>", {})
			vim.keymap.set("n", "<leader>g", ":Neotree toggle git_status bottom<CR>", {})

			require("neo-tree").setup({
				popup_border_style = "rounded",

				filesystem = {
					window = {
						position = "left",
						width = 50,
					},
				},
				buffers = {
					window = {
						height = 30,
					},
				},
				git_status = {
					window = {
						height = 30,
					},
				},
			})
		end,
	},
}

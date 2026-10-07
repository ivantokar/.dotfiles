return {
	"ivantokar/xmap.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- Optional but recommended
	},
	config = function()
		require("xmap").setup({
			-- render = { relative_prefix = { separator = " ", direction = { down = "j", up = "k", current = "·" } } },
			-- Symbol filtering per language (keyed by filetype)
			symbols = {
				lua = {
					keywords = {},
					exclude = {},
					highlight_keywords = {},
				},
				swift = {
					keywords = {}, -- When empty, uses Swift defaults
					exclude = { "let", "var" }, -- e.g. { "let", "var" }
					highlight_keywords = {}, -- Optional override for keyword highlighting list
				},
				typescript = {
					exclude = { "var", "let", "property" },
				},
				typescriptreact = {
					exclude = { "var", "let", "property" },
				},
			},
		})
	end,
}

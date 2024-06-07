return {
	{
		-- Multicursors

		"mg979/vim-visual-multi",
		branch = "master",
	},
	{
		-- Auto pairs {} [] () '' "" ``

		"windwp/nvim-autopairs",

		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		-- Autotag for html, jsx, tsx, xml, xhtml

		"windwp/nvim-ts-autotag",

		opts = {
			event = "BufWritePre",
			enable = true,
		},

		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
			})
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
		"stevearc/conform.nvim",

		opts = {},

		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- python = { "isort", "black" },
					javascript = { { "prettier" } },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}

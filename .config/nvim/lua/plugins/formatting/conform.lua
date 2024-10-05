return {
	-- Autoformat on save

	"stevearc/conform.nvim",

	opts = {},

	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				lua = { "stylua" },
				typescript = { "prettierd" },
				swift = { "swiftformat", "swiftlint" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
}

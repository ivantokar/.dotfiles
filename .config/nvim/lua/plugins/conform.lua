return {
	-- Autoformat on save

	"stevearc/conform.nvim",

	opts = {},

	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = { "prettierd" },
<<<<<<< HEAD
				swift = { "swiftformat" },
=======
				swift = { "swiftformat", "swiftlint" },

>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
			},

			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
}

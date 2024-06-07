return {
	{
		-- LSP Formatter

		"nvimtools/none-ls.nvim",

		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},

		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- require("none-ls.diagnostics.eslint_d"),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
				},
			})

			-- Format code
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
		end,
	},
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
		-- Autoformat on save

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
	{
		-- Commenting

		"numToStr/Comment.nvim",

		opts = {
			-- add any options here
		},

		lazy = false,

		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		-- Commenting for JSX, TSX, etc.

		"JoosepAlviste/nvim-ts-context-commentstring",

		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		-- Search and replace

		"nvim-pack/nvim-spectre",

		config = function()
			require("spectre").setup()

			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
}

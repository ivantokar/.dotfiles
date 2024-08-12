return {
	{
		-- LSP Formatter

		"nvimtools/none-ls.nvim",

		dependencies = { "nvimtools/none-ls-extras.nvim" },

		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.swiftformat,
					null_ls.builtins.formatting.swiftlint,
				},
			})
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
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway

		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			"nvim-treesitter/nvim-treesitter",

			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			local markview = require("markview")
			local presets = require("markview.presets")

			markview.setup({
				headings = presets.headings.glow_labels,
			})

			vim.cmd("Markview enableAll")
		end,
	},
}

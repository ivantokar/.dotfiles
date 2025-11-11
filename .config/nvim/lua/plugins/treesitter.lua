return {
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Install the parser for stencil
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.stencil = {
				install_info = {
					url = "https://github.com/ivantokar/tree-sitter-stencil",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "stencil",
			}

			vim.filetype.add({
				extension = {
					stencil = "stencil",
				},
			})

			require("nvim-treesitter.configs").setup({
				ignore_install = {},
				modules = {},
				-- A list of parser names, or "all"
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"c",
					"lua",
					"jsdoc",
					"bash",
					"graphql",
					"latex",
					"markdown",
					"vue",
					"html",
					"css",
					"norg",
					"svelte",
					"stencil",
					"tsx",
					"json",
					"toml",
					"yaml",
					"markdown_inline",
					"scss",
					"typst",
					"astro",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
				auto_install = true,

				indent = {
					enable = true,
				},

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})

			vim.cmd("TSInstallFromGrammar stencil")
		end,
	},
}

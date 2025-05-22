return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = {
					"vimdoc",
<<<<<<< HEAD
					"javascript",
					"typescript",
					"c",
=======
                    'regex',
					"c",
					"swift",
>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
					"lua",
					"jsdoc",
					"bash",
					"graphql",
<<<<<<< HEAD
					"markdown",
					"markdown_inline",
					"html",
					"twig",
					"css",
					"scss",
					"json",
					"yaml",
					"toml",
					"python",
					"java",
					"rust",
					"php",
					"cpp",
					"query",
					"graphql",
=======
					"javascript",
					"typescript",
					"markdown",
					"markdown_inline",
					"html",
>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
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
<<<<<<< HEAD
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"nelsyeung/twig.vim",
		ft = { "twig", "stencil" },

		config = function()
			vim.filetype.add({
				extension = {
					stencil = "twig",
				},
			})
=======
					additional_vim_regex_highlighting = { "markdown" },
				},
			})

			local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
			}

			vim.treesitter.language.register("templ", "templ")
>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
		end,
	},
}

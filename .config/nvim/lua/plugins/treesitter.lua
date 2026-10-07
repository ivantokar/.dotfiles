local parsers = {
	"astro",
	"bash",
	"c",
	"css",
	"graphql",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"scss",
	"swift",
	"tsx",
	"typescript",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Neovim 0.12 owns highlighting, folds, and injections. nvim-treesitter
			-- supplies the parser installer and its maintained query collection.
			require("nvim-treesitter").setup({})

			vim.filetype.add({ extension = { mdx = "mdx", stencil = "stencil" } })
			vim.treesitter.language.register("markdown", "mdx")

			-- The current nvim-treesitter registry loads custom parser definitions
			-- from User TSUpdate. Register first, then trigger it for this session.
			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup("UserStencilParser", { clear = true }),
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").stencil = {
						install_info = {
							url = "https://github.com/ivantokar/tree-sitter-stencil",
							files = { "src/parser.c", "src/scanner.c" },
							branch = "main",
						},
					}
				end,
			})
			vim.api.nvim_exec_autocmds("User", { pattern = "TSUpdate" })
			vim.treesitter.language.register("stencil", "stencil")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- Missing parsers install in the background; :TSUpdate runs after plugin updates.
			require("nvim-treesitter").install(vim.list_extend({ "stencil" }, parsers))
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
			per_filetype = {
				html = { enable_close = false },
			},
		},
	},
}

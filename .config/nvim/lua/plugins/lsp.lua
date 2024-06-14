return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Organize imports for typescript
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			-- TypeScript
			lspconfig.tsserver.setup({
				capabilities = capabilities,
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})

			-- Emmet
			lspconfig.emmet_language_server.setup({
				filetypes = {
					"typescriptreact",
				},
				-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
				-- **Note:** only the options listed in the table are supported.
				init_options = {
					---@type table<string, string>
					includeLanguages = {},
					--- @type string[]
					excludeLanguages = {},
					--- @type string[]
					extensionsPath = {},
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
					preferences = {},
					--- @type boolean Defaults to `true`
					showAbbreviationSuggestions = true,
					--- @type "always" | "never" Defaults to `"always"`
					showExpandedAbbreviation = "always",
					--- @type boolean Defaults to `false`
					showSuggestionsAsSnippets = false,
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
					syntaxProfiles = {},
					--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
					variables = {},
				},
			})

			-- GraphQL
			lspconfig.graphql.setup({
				capabilities = capabilities,
				filetypes = { "graphql", "gql", "typescriptreact", "typescript" },
				-- root_dir = lspconfig.util.root_pattern(
				-- 	".graphqlrc",
				-- ),
				-- flags = {
				-- 	debounce_text_changes = 150,
				-- },
			})

			-- Swift
			lspconfig.sourcekit.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

			-- Go to definition
			vim.keymap.set("n", "<leader>gd", function()
				require("telescope.builtin").lsp_definitions()
			end, {
				noremap = true,
				silent = true,
			})

			-- Go to references
			vim.keymap.set("n", "<leader>gr", function()
				require("telescope.builtin").lsp_references()
			end, {
				noremap = true,
				silent = true,
			})

			-- Code action
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}

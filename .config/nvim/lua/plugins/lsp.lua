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

			lspconfig.tsserver.setup({
				capabilities = capabilities,
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})

			lspconfig.graphql.setup({
				capabilities = capabilities,
				-- filetypes = { "graphql", "gql", "typescriptreact", "typescript" },
				-- root_dir = lspconfig.util.root_pattern(
				-- 	".graphqlrc",
				-- ),
				-- flags = {
				-- 	debounce_text_changes = 150,
				-- },
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

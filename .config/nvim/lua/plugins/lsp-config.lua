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
		-- config = function()
		-- 	require("mason-lspconfig").setup({
		-- 		ensure_installed = {
		-- 			"lua_ls",
		-- 			"tsserver",
		-- 		},
		-- 	})
		-- end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
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
				-- on_attach = on_attach,
				capabilities = capabilities,
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})
            
            lspconfig.sourcekit.setup({
                capabilities = capabilities,
            })

			lspconfig.graphql.setup({
				capabilities = capabilities,
                cmd = { "graphql-lsp", "server", "-m", "stream" },
                filetypes = { "graphql", "javascriptreact", "typescriptreact" },
				root_dir = lspconfig.util.root_pattern('.git', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*'),
				-- flags = {
				-- 	debounce_text_changes = 150,
				-- },
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

			vim.keymap.set("n", "<leader>gd", function()
				require("telescope.builtin").lsp_definitions()
			end, {
				noremap = true,
				silent = true,
			})

			vim.keymap.set("n", "<leader>gr", function()
				require("telescope.builtin").lsp_references()
			end, {
				noremap = true,
				silent = true,
			})

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}

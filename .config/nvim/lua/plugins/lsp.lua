return {
	-- LSP
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
	},
	{
		"neovim/nvim-lspconfig",

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- Set up diagnostic signs (modern API for Neovim 0.11+)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			-- Note: In Neovim 0.12+, diagnostic signs should be configured via vim.diagnostic.config()

			-- Configure LSP handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				max_width = 80,
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- Global LSP configuration
			vim.lsp.config("*", {
				capabilities = capabilities,
				root_markers = { ".git" },
			})

			-- Organize imports for typescript
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

			-- Lua LSP
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
						hint = {
							enable = true,
						},
						format = {
							enable = false, -- Use stylua via conform.nvim
						},
					},
				},
			})

			-- TypeScript LSP
			local inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			}

			vim.lsp.config("ts_ls", {
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
				settings = {
					typescript = {
						inlayHints = inlayHints,
						format = {
							enable = false, -- Use prettierd via conform.nvim
						},
					},
					javascript = {
						inlayHints = inlayHints,
						format = {
							enable = false, -- Use prettierd via conform.nvim
						},
					},
				},
			})

			-- Swift / C++ LSP
			vim.lsp.config("sourcekit", {
				cmd = { "sourcekit-lsp" },
				filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
				root_markers = {
					"Package.swift",
					".git",
					"compile_commands.json",
					"compile_flags.txt",
				},
			})

			-- Emmet LSP
			vim.lsp.config("emmet_language_server", {
				filetypes = {
					"html",
					"css",
					"scss",
					"sass",
					"less",
					"typescriptreact",
					"javascriptreact",
				},
			})

			-- GraphQL LSP
			vim.lsp.config("graphql", {
				filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
				root_markers = {
					".graphqlrc",
					".graphqlrc.json",
					".graphqlrc.yaml",
					".graphqlrc.yml",
					"graphql.config.js",
					"graphql.config.ts",
					".git",
				},
			})

			-- Enable all configured LSP servers
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("sourcekit")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("graphql")

			-- LspAttach autocmd for buffer-local keymaps and settings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf

					-- Enable inlay hints if supported
					if client and client.supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					-- Buffer-local keymaps
					local opts = { buffer = bufnr, silent = true }

					-- Note: Many keymaps are now built-in by default in Neovim 0.11+:
					-- - grn: Rename
					-- - grr: References
					-- - gri: Implementation
					-- - grt: Type definition
					-- - gra: Code actions (Normal and Visual)
					-- - gO: Document symbols
					-- - [d / ]d: Navigate diagnostics
					-- - <C-W>d: Show diagnostics in float
					-- - <C-S>: Signature help (Insert mode)

					-- Custom keymaps that aren't built-in or override defaults

					-- Show documentation (K is not mapped by default)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, {
						desc = "LSP: Hover documentation",
					}))

					-- Go to definition (gd is not mapped by default)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to definition",
					}))

					-- Go to declaration (gD is not mapped by default)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {
						desc = "LSP: Go to declaration",
					}))

					-- Show diagnostics in floating window (custom binding, <C-W>d is built-in)
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, vim.tbl_extend("force", opts, {
						desc = "LSP: Show line diagnostics",
					}))

					-- Telescope integration for better UI
					vim.keymap.set("n", "<leader>gd", function()
						require("telescope.builtin").lsp_definitions()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Find definitions (Telescope)",
					}))

					vim.keymap.set("n", "<leader>gr", function()
						require("telescope.builtin").lsp_references()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Find references (Telescope)",
					}))

					vim.keymap.set("n", "<leader>gi", function()
						require("telescope.builtin").lsp_implementations()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Find implementations (Telescope)",
					}))

					vim.keymap.set("n", "<leader>gt", function()
						require("telescope.builtin").lsp_type_definitions()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Find type definitions (Telescope)",
					}))

					vim.keymap.set("n", "<leader>gs", function()
						require("telescope.builtin").lsp_document_symbols()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Document symbols (Telescope)",
					}))

					vim.keymap.set("n", "<leader>gS", function()
						require("telescope.builtin").lsp_workspace_symbols()
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Workspace symbols (Telescope)",
					}))

					-- Additional custom keymaps

					-- Code action (also available via gra)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
						desc = "LSP: Code action",
					}))

					-- Rename (also available via grn)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
						desc = "LSP: Rename symbol",
					}))

					-- Format (use conform.nvim if available)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Format buffer",
					}))

					-- Toggle inlay hints
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
					end, vim.tbl_extend("force", opts, {
						desc = "LSP: Toggle inlay hints",
					}))
				end,
			})
		end,
	},
	{
		-- Completion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
		},

		config = function()
			local lspkind = require("lspkind")
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()

			-- Better tab completion behavior
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					-- Super-Tab like mapping
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
						before = function(entry, vim_item)
							return vim_item
						end,
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})

			-- Set configuration for specific filetype
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore)
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}

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
        opts = {
            auto_install = true,
        },
    },
    -- {
    -- 	"kabouzeid/nvim-lspinstall",
    --
    -- 	config = function()
    -- 		local lspconfig = require("lspconfig")
    -- 		local lspinstall = require("lspinstall")
    --
    -- 		lspinstall.setup()
    --
    -- 		local servers = lspinstall.installed_servers()
    -- 		for _, server in pairs(servers) do
    -- 			lspconfig[server].setup({})
    -- 		end
    -- 	end,
    -- },
    {
        "neovim/nvim-lspconfig",

        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Override the LspInfo window configuration
            require("lspconfig.ui.windows").default_options = {
                border = "rounded",
            }
            -- Set up the hover window configuration
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
                max_width = 80,
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
                    "typescriptreact, typescript, javascript, javascriptreact, html, css, scss",
                },
            })

            -- TailwindCSS
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "javascript",
                    "typescript",
                    "typescriptreact",
                    "javascriptreact",
                    "swift",
                },
            })

            -- GraphQL
            lspconfig.graphql.setup({
                capabilities = capabilities,
                filetypes = { "graphql", "gql", "typescriptreact", "typescript", "typescriptreact", "javascript" },
            })

            -- Swift
            lspconfig.sourcekit.setup({
                capabilities = capabilities,
            })
        end,
    },
    -- {
    -- 	"luckasRanarison/tailwind-tools.nvim",
    -- 	name = "tailwind-tools",
    -- 	build = ":UpdateRemotePlugins",
    -- 	dependencies = {
    -- 		"nvim-treesitter/nvim-treesitter",
    -- 		"nvim-telescope/telescope.nvim", -- optional
    -- 		"neovim/nvim-lspconfig", -- optional
    -- 	},
    --
    -- 	config = function()
    -- 		require("tailwind-tools").setup({
    -- 			extension = {
    -- 				queries = {}, -- a list of filetypes having custom `class` queries
    -- 				patterns = { -- a map of filetypes to Lua pattern lists
    -- 					swift = {
    -- 						-- Matches `.class("...")` or `.class('...')`
    -- 						"%.class%((['\"])(.-)%1%)",
    -- 					},
    -- 				},
    -- 			},
    -- 		})
    -- 	end,
    -- },
    -- Completion
    {
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
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
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
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                }, {
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        -- before = function(entry, vim_item)
                        -- 	return vim_item
                        -- end,
                    }),
                },
            })
        end,
    },
}

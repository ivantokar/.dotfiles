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
                settings = {
                    Lua = {
                        hint = {
                            enable = true,
                        },
                    },
                },
            })

            -- TypeScript
            -- ts_ls settings
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

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                commands = {
                    OrganizeImports = {
                        organize_imports,
                        description = "Organize Imports",
                    },
                },
                settings = {
                    typescript = {
                        inlayHints = inlayHints,
                    },
                    javascript = {
                        inlayHints = inlayHints,
                    },
                },
            })

            -- Swift / C++
            -- TODO: Fix inlay hints, make settings according to https://www.swift.org/documentation/articles/zero-to-swift-nvim.html
            lspconfig.sourcekit.setup({
                capabilities = capabilities,
                settings = {
                    sourcekit = {
                        inlayHints = {
                            enabled = true,
                            -- showVariableTypes = true,
                            -- showFunctionParameterNames = true,
                            -- showFullyQualifiedNames = false,
                            -- parameterNamesPrefix = ":",
                            -- parameterTypesPrefix = ":",
                            -- variableTypesPrefix = ":",
                            -- typeDecorationStyle = "prefix", -- can be "none", "prefix", or "postfix"
                            -- placeholderDecoration = true,
                            -- suppressWhenLineBreaks = false,
                            -- suppressForParametersThatMatchMethodName = true,
                            -- excludeTypeFromVariableType = true,
                            -- maxLength = nil, -- nil means no limit
                        },
                    },
                },

                -- filetypes = { "swift", "cpp" },
                -- settings = {
                --     sourcekit = {
                --         suggestImports = true,
                --         inlayHints = {
                --             enabled = true,
                --             showVariableTypes = true,
                --             showFunctionParameterNames = true,
                --             showFullyQualifiedNames = false,
                --         },
                --     },
                --     clangd = {
                --         InlayHints = {
                --             Designators = true,
                --             Enabled = true,
                --             ParameterNames = true,
                --             DeducedTypes = true,
                --         },
                --         fallbackFlags = { "-std=c++20" },
                --     },
                -- },
            })

            -- Emmet
            lspconfig.emmet_language_server.setup({
                filetypes = {
                    "typescriptreact, html, css, scss",
                },
            })

            -- GraphQL
            lspconfig.graphql.setup({
                capabilities = capabilities,
                filetypes = { "typescriptreact", "typescript" },
            })

            lspconfig.kulala.setup({
                capabilities = capabilities,
                filetypes = { "http", "rest" },
            })

            -- LSP keybindings

            -- Show documentation on hover
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })

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

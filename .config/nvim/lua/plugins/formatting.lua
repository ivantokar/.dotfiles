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
}

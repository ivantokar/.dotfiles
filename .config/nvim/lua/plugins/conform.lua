return {
    -- Autoformat on save

    "stevearc/conform.nvim",

    opts = {},

    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                -- Swift formatting handled by xcodebuild.nvim or sourcekit-lsp
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}

return {
    "nvimtools/none-ls.nvim",

    dependencies = { "nvimtools/none-ls-extras.nvim" },

    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Formatting is handled by conform.nvim
                -- Add diagnostics and code actions here if needed in the future
                -- Example: null_ls.builtins.diagnostics.eslint_d
            },
        })
    end,
}

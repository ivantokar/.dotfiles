return {
    "nvimtools/none-ls.nvim",

    dependencies = { "nvimtools/none-ls-extras.nvim" },

    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettierd,
                -- Swift formatting removed - handled by xcodebuild.nvim or sourcekit-lsp
            },
        })
    end,
}

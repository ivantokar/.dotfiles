return {
    "nvimtools/none-ls.nvim",

    dependencies = { "nvimtools/none-ls-extras.nvim" },

    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.swift_format.with({
                    command = "swift-format",
                    args = { "format", "--stdin", "--assume-filename", "$FILENAME" },
                    filetypes = { "swift" },
                }),
                null_ls.builtins.formatting.swiftlint,
            },
        })
    end,
}

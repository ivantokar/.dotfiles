-- Keep the prior language-specific formatting choices within LazyVim's formatter.
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "prettierd", "stylua" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        swift = { "swift" },
      },
      formatters = {
        -- Use four spaces for JavaScript-family files.
        prettierd = {
          prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
        },
        -- Apply the managed four-space policy when formatting Swift source.
        swift = {
          args = {
            "format",
            "--configuration",
            vim.fn.stdpath("config") .. "/swift-format.json",
            "$FILENAME",
            "--in-place",
          },
        },
      },
    },
  },
}

-- Restore the personal symbol map with filtering for the languages in use.
return {
  {
    "ivantokar/xmap.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("xmap").setup({
        symbols = {
          lua = {
            keywords = {},
            exclude = {},
            highlight_keywords = {},
          },
          swift = {
            keywords = {},
            exclude = { "let", "var" },
            highlight_keywords = {},
          },
          typescript = {
            exclude = { "var", "let", "property" },
          },
          typescriptreact = {
            exclude = { "var", "let", "property" },
          },
        },
      })
    end,
  },
}

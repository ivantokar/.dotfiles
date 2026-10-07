require("plugins.gitsigns")

return {
    "petertriho/nvim-scrollbar",
    config = function()
        require("scrollbar").setup()
        require("scrollbar.handlers.gitsigns").setup()
    end,
}

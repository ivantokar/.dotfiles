return {
    -- Indent Blankline

    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",
    opts = {},

    config = function()
        require("ibl").setup({
            indent = { char = "│" },
        })
    end,
}

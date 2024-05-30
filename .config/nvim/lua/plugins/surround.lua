return {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",

    config = function()
        require("nvim-surround").setup({
            -- mappings_style = "surround",
            -- mappings = {
            --     b = { "(", ")" },
            --     B = { "{", "}" },
            --     r = { "[", "]" },
            --     s = { "'", "'" },
            --     S = { '"', '"' },
            --     t = { "<", ">" },
            -- },
        })
    end,
}

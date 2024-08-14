return {
    {
        -- Rose Pine

        "rose-pine/neovim",

        name = "rose-pine",

        config = function()
            require("rose-pine").setup({
                variant = "auto", -- auto, main, moon, or dawn
                dark_variant = "main", -- main, moon, or dawn
                light_variant = "dawn", -- main, moon, or dawn
                dim_inactive_windows = true,
                extend_background_behind_borders = true,

                styles = {
                    bold = true,
                    italic = true,
                    -- transparency = true,
                },
            })

            vim.cmd("colorscheme rose-pine")
        end,
    },
}

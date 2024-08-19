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
    {

        -- Catppuccino

        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                    transparent = true,
                },
            })

            -- vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
}

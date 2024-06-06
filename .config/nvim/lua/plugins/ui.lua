return {
    {
        -- Grovebox Material

        "sainnhe/gruvbox-material",

        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_enable_bold = true
            vim.g.gruvbox_material_better_performance = false
            vim.g.gruvbox_material_transparent_background = true
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_palette = "mix"
            vim.g.gruvbox_material_current_word = "bold"
            vim.g.gruvbox_material_enable_italic_comment = true
            vim.g.gruvbox_material_enable_italic_string = true

            vim.cmd.colorscheme("gruvbox-material")
        end,
    },

    {
        -- Lualine

        "nvim-lualine/lualine.nvim",

        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "│", right = "│" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
    {
        -- Indent Blankline

        "lukas-reineke/indent-blankline.nvim",

        main = "ibl",
        opts = {},

        config = function()
            require("ibl").setup({
                indent = { char = "│" },
            })
        end,
    },
}

return {
    {
        "akinsho/bufferline.nvim",

        version = "*",

        event = "BufReadPre",

        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = false,
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and "E:" or "W:"
                        return " " .. icon .. count
                    end,
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    separator_style = "thin",
                    show_buffer_close_icons = false,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                    },
                },
            })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",

        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)
            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            vim.keymap.set("n", "<C-1>", function()
                harpoon:list():select(1)
            end)
            vim.keymap.set("n", "<C-2>", function()
                harpoon:list():select(2)
            end)
            vim.keymap.set("n", "<C-3>", function()
                harpoon:list():select(3)
            end)
            vim.keymap.set("n", "<C-4>", function()
                harpoon:list():select(4)
            end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-<>", function()
                harpoon:list():prev()
            end)
            vim.keymap.set("n", "<C-S->>", function()
                harpoon:list():next()
            end)
        end,
    },
}

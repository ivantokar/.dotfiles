return {
    {
        "akinsho/bufferline.nvim",

        version = "*",

        event = "BufReadPre",

        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and "E:" or "W:"
                        return " " .. icon .. count
                    end,
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    separator_style = { "", "" },
                    indicator = {
                        style = "none",
                    },
                    always_show_bufferline = false,
                    show_buffer_close_icons = false,
                    color_icons = true,
                },
            })
        end,
    },
}

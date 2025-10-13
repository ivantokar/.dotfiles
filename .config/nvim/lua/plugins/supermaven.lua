return {
    "supermaven-inc/supermaven-nvim",

    config = function()
        require("supermaven-nvim").setup({
            -- Disable inline completion to avoid messy appearance
            -- Only show suggestions in the completion menu
            disable_inline_completion = true,
            disable_keymaps = true,

            log_level = "info",  -- "off" to disable logging, "debug" for more verbose

            -- ignore_filetypes = { cpp = true }, -- Disable for specific languages
            condition = function()
                return false  -- Supermaven always enabled
            end,
        })

        -- Set custom highlight for Supermaven suggestions in cmp menu
        vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
    end,
}

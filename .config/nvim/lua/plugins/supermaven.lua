return {
    "supermaven-inc/supermaven-nvim",

    config = function()
        require("supermaven-nvim").setup({
            keymaps = {
                accept_suggestion = "<M-a>",     -- Accept full suggestion (alternative to Tab)
                clear_suggestion = "<M-c>",      -- Clear suggestion
                accept_word = "<M-w>",           -- Accept next word
                next_completion = "<M-n>",       -- Next suggestion (not needed in cmp integration)
                previous_completion = "<M-p>",   -- Previous suggestion (not needed in cmp integration)
            },

            -- ignore_filetypes = { cpp = true }, -- Disable for specific languages
            color = {
                suggestion_color = "#6e6a86",
                cterm = 244,
            },
            log_level = "info",                -- "off" to disable logging, "debug" for more verbose
            disable_inline_completion = false, -- Keep inline suggestions enabled
            disable_keymaps = false,           -- Keep alt keymaps as fallback
            condition = function()
                return false                   -- Supermaven always enabled
            end,
        })

        -- Set custom highlight for Supermaven suggestions in cmp menu
        vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
    end,
}

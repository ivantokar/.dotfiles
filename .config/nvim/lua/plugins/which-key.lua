return {
<<<<<<< HEAD
    "folke/which-key.nvim",
    event = "VeryLazy",
=======
    -- Which key for keybindings

    "folke/which-key.nvim",

    -- dependencies = { "echasnovski/mini.icons", version = false },

    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
<<<<<<< HEAD
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
=======

    setup = function()
        local wk = require("which-key")

        wk.setup({})
    end,
>>>>>>> d26398d2152baf0f825be4b2dfc9f2ddfbe01fab
}

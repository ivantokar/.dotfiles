return {
    {
        "mhinz/vim-startify",
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened

        config = function()
            require("persistence").setup({
                dir = vim.fn.stdpath("data") .. "/sessions/",
                -- minimum number of file buffers that need to be open to save
                -- Set to 0 to always save
                need = 1,
                branch = true, -- use git branch to save session
            })
        end,
    },

    {
        -- Undotree for undo history

        "mbbill/undotree",

        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 40
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_HighlightChangedWithSign = 1
        end,
    },
    {
        -- Which key for keybindings

        "folke/which-key.nvim",

        dependencies = { "echasnovski/mini.icons", version = false },

        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },

        setup = function()
            local wk = require("which-key")

            wk.setup({})
        end,
    },
    -- {
    -- 	"vhyrro/luarocks.nvim",
    -- 	priority = 1001, -- this plugin needs to run before anything else
    -- 	opts = {
    -- 		rocks = { "magick" },
    -- 	},
    -- },
    -- {
    -- 	"3rd/image.nvim",
    -- 	dependencies = { "luarocks.nvim" },
    -- 	config = function()
    -- 		require("image").setup({
    -- 			backend = "kitty",
    -- 			integrations = {
    -- 				markdown = {
    -- 					enabled = true,
    -- 					clear_in_insert_mode = false,
    -- 					download_remote_images = true,
    -- 					only_render_image_at_cursor = false,
    -- 					filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    -- 				},
    -- 				neorg = {
    -- 					enabled = true,
    -- 					clear_in_insert_mode = false,
    -- 					download_remote_images = true,
    -- 					only_render_image_at_cursor = false,
    -- 					filetypes = { "norg" },
    -- 				},
    -- 				html = {
    -- 					enabled = false,
    -- 				},
    -- 				css = {
    -- 					enabled = false,
    -- 				},
    -- 			},
    -- 			max_width = nil,
    -- 			max_height = nil,
    -- 			max_width_window_percentage = nil,
    -- 			max_height_window_percentage = 50,
    -- 			window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    -- 			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    -- 			editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    -- 			tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    -- 			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    -- 		})
    -- 	end,
    -- },
}

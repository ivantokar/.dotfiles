return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = {
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "c",
                    "lua",
                    "jsdoc",
                    "bash",
                    "graphql",
                    "markdown",
                    "markdown_inline",
                    "html",
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
                auto_install = true,

                indent = {
                    enable = true,
                },

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = { "markdown" },
                },
            })

            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }

            vim.treesitter.language.register("templ", "templ")
        end,
    },
    {
        -- Lualine

        "nvim-lualine/lualine.nvim",

        dependencies = { "nvim-tree/nvim-web-devicons" },

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
                    globalstatus = true,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = {
                        "mode",
                    },
                    lualine_b = {
                        "branch",
                        "diff",
                        "diagnostics",
                    },
                    lualine_c = {
                        {
                            "buffers",
                            show_filename_only = true, -- Shows shortened relative path when set to false.
                            hide_filename_extension = false, -- Hide filename extension when set to true.
                            show_modified_status = true, -- Shows indicator when the buffer is modified.

                            mode = 0,   -- 0: Shows buffer name
                            -- 1: Shows buffer index
                            -- 2: Shows buffer name + buffer index
                            -- 3: Shows buffer number
                            -- 4: Shows buffer name + buffer number

                            max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                            -- it can also be a function that returns
                            -- the value of `max_length` dynamically.
                            -- filetype_names = {
                            TelescopePrompt = "Telescope",
                            -- 	dashboard = "Dashboard",
                            -- 	packer = "Packer",
                            fzf = "FZF",
                            alpha = "Alpha",
                            -- }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                            -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                            use_mode_colors = false,

                            -- buffers_color = {
                            -- 	-- Same values as the general color option can be used here.
                            -- 	active = "lualine_{section}_normal", -- Color for active buffer.
                            -- 	inactive = "lualine_{section}_inactive", -- Color for inactive buffer.
                            -- },

                            symbols = {
                                modified = " ●", -- Text to show when the buffer is modified
                                alternate_file = "#", -- Text to show to identify the alternate file
                                directory = "", -- Text to show when the buffer is a directory
                            },
                        },
                    },

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
    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },
    {
        "petertriho/nvim-scrollbar",
        config = function()
            require("scrollbar").setup()
            require("scrollbar.handlers.gitsigns").setup()
        end,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        opts = {},
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                                         desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",                 desc = "Todo/Fix/Fixme" },
        }
        ,
    },
}

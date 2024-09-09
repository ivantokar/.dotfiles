return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            popup_border_style = "rounded",
            -- event_handlers = {
            -- 	{
            -- 		event = "file_open_requested",
            -- 		handler = function()
            -- 			-- auto close
            -- 			-- vimc.cmd("Neotree close")
            -- 			-- OR
            -- 			require("neo-tree.command").execute({ action = "close" })
            -- 		end,
            -- 	},
            -- },
            filesystem = {
                window = {
                    position = "left",
                    width = 60,
                    -- mappings = {
                    --     ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    -- },
                },
                symbols = {
                    deleted = "",
                },
            },
        })

        -- vim.keymap.set("n", "<leader>t", ":Neotree toggle filesystem left<CR>", {})
        vim.keymap.set("n", "<leader>t", ":Neotree toggle filesystem float<CR>", {})
    end,
}

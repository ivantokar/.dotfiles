return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			popup_border_style = "rounded",
			enable_diagnostics = true,
			default_component_configs = {
				diagnostics = {
					symbols = {
						error = "",
						warn = "",
						info = "ⓘ",
						hint = "󰠠",
					},
					highlights = {
						error = "DiagnosticError",
						warn = "DiagnosticWarn",
						info = "DiagnosticInfo",
						hint = "DiagnosticHint",
					},
				},
			},
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
				follow_current_file = {
					enabled = true, -- Focus the current file in the tree when opening a buffer
					leave_dirs_open = true, -- Close directories when leaving them
				},
				use_libuv_file_watcher = true, -- Auto-refresh tree on file system changes
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					-- hide_dotfiles = false,
					-- hide_gitignored = false,
					-- hide_hidden = false, -- only works on Windows for hidden files/directories
				},
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
			-- buffers = {
			-- 	show_unloaded = true,
			-- },
		})

		vim.keymap.set("n", "<leader>B", ":Neotree toggle buffers left<CR>", {})
		vim.keymap.set("n", "<leader>b", ":Neotree toggle buffers float<CR>", {})
		vim.keymap.set("n", "<leader>E", ":Neotree toggle filesystem left<CR>", {})
		vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem float<CR>", {})
	end,
}

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fa",
				function()
					require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
				end,
				desc = "Find all files",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fw",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Grep word",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fo",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume picker",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = " ",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						width = 0.9,
						height = 0.85,
						horizontal = { prompt_position = "top", preview_width = 0.55 },
					},
					path_display = { "truncate" },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files = { hidden = true },
					buffers = { sort_lastused = true, sort_mru = true },
					oldfiles = { cwd_only = true },
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
}

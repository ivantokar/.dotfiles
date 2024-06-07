return {
	{
		"stevearc/oil.nvim",

		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},

		config = function()
			vim.keymap.set("n", "<leader>t", ":Neotree toggle filesystem left<CR>", {})

			require("neo-tree").setup({
				popup_border_style = "rounded",

				filesystem = {
					window = {
						position = "left",
						width = 50,
					},
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },

		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "ha", function()
				harpoon:list():add()
			end, {
				desc = "Add file to Harpoon list",
			})
			-- vim.keymap.set("n", "<leader>h", function()
			-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
			-- end, {
			-- 	desc = "Toggle Harpoon",
			-- })

			-- Set <space>1..<space>5 be my shortcuts to moving to the files
			for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
				vim.keymap.set("n", string.format("<space>%d", idx), function()
					harpoon:list():select(idx)
				end, {
					desc = string.format("Move to Harpoon file %d", idx),
				})
			end

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local make_finder = function()
					local paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(paths, item.value)
					end

					return require("telescope.finders").new_table({
						results = paths,
					})
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = make_finder(),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_buffer_number, map)
							map(
								"i",
								"<c-d>", -- your mapping here
								function()
									local state = require("telescope.actions.state")
									local selected_entry = state.get_selected_entry()
									local current_picker = state.get_current_picker(prompt_buffer_number)

									harpoon:list():remove(selected_entry)
									current_picker:refresh(make_finder())
								end
							)

							return true
						end,
					})
					:find()
			end

			vim.keymap.set("n", "<leader>h", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })
		end,
	},
}

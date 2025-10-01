return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
			},
			preview_config = {
				border = "rounded",
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous hunk" })

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Git: Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Git: Reset hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git: Stage hunk (visual)" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git: Reset hunk (visual)" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "Git: Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git: Undo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Git: Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: Preview hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Git: Blame line" })
				map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "Git: Toggle line blame" })
				map("n", "<leader>hd", gs.diffthis, { desc = "Git: Diff this" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "Git: Diff this ~" })
				map("n", "<leader>htd", gs.toggle_deleted, { desc = "Git: Toggle deleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Select hunk" })
			end,
		})
	end,
}

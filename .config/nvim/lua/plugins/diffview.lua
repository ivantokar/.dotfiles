return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
			use_icons = true,
		})

		-- Keymaps
		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: Open diff view",
		}))

		vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: Close diff view",
		}))

		vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: File history",
		}))

		vim.keymap.set("n", "<leader>gdH", "<cmd>DiffviewFileHistory %<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: Current file history",
		}))

		vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewToggleFiles<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: Toggle file panel",
		}))

		vim.keymap.set("n", "<leader>gdr", "<cmd>DiffviewRefresh<cr>", vim.tbl_extend("force", opts, {
			desc = "Git: Refresh diff",
		}))
	end,
}

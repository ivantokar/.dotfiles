return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		-- add any custom options here
	},

	config = function()
		require("persistence").setup({
			auto_save = true,
			auto_restore = true,
			autosave_sessions = {
				windows = true,
				layout = true,
				ui = true,
				diagnostics = true,
			},
			autosave_interval = 1000,
		})
	end,
}

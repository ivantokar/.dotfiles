return {
	"rcarriga/nvim-notify",

	config = function()
		require("notify").setup({
			stages = "fade_in_slide_out", -- animation style
			timeout = 3000, -- time in ms before disappearing
			background_colour = "#000000", -- use Normal highlight group background
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
			max_width = 80,
			max_height = 10,
			render = "compact", -- or "default", "minimal", "simple"
		})
		vim.notify = require("notify") -- override default vim.notify
	end,
}
